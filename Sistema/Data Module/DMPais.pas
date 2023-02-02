unit DMPais;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMPais = class(TDataModule)
    DPais: TDataSource;
    TPais: TFDMemTable;
    TPaiscodigo: TIntegerField;
    TPaiscodigoIbge: TStringField;
    TPaisnome: TStringField;
    TPaiscadastradoPor: TStringField;
    TPaisalteradoPor: TStringField;
    TPaisdataCadastro: TStringField;
    TPaisdataAlteracao: TStringField;
    TPaisstatus: TStringField;
    TPaiscodigoUsuarioCadastro: TIntegerField;
    TPaiscodigoUsuarioAlteracao: TIntegerField;
  private

  public
    procedure consultarDados();
    function cadastrarPais: Boolean;
    function alterarPais: Boolean;
    function inativarPais: Boolean;
  end;

var
  FDMPais: TFDMPais;

implementation

uses UFuncao, UConexao, Pais;

{$R *.dfm}

function TFDMPais.cadastrarPais: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
  jsonArray: TJSONArray;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'pais';
  Conexao.AtribuirBody('nomePais', TPaisnome.Value);
  Conexao.AtribuirBody('codigoIBGE', TPaiscodigoIbge.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      TPaiscodigo.Value := json.GetValue<Integer>('codigo', 0);
      TPaiscadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TPaisalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TPaisdataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TPaisdataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TPaisstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMPais.alterarPais: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
  jsonArray: TJSONArray;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'pais/' + IntToStrSenaoZero(TPaiscodigo.Value);
  Conexao.AtribuirBody('nomePais', TPaisnome.Value);
  Conexao.AtribuirBody('codigoIBGE', TPaiscodigoIbge.Value);
  Conexao.AtribuirBody('status', TPaisstatus.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      TPaiscodigo.Value := json.GetValue<Integer>('codigo', 0);
      TPaiscadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TPaisalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TPaisdataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TPaisdataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TPaisstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMPais.consultarDados;
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  i, limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (FPais.ELocalizarNome.Text <> '') then
  begin
    Conexao.AtribuirParametro('nomePais', FPais.ELocalizarNome.Text);
  end;

  if (FPais.ELocalizarCodigoIBGE.Text <> '') then
  begin
    Conexao.AtribuirParametro('codigoIBGE', FPais.ELocalizarCodigoIBGE.Text);
  end;

  if FPais.CBMostrarInativo.Checked then
  begin
    Conexao.AtribuirParametro('status', 'I');
  end
  else
  begin
    Conexao.AtribuirParametro('status', 'A');
  end;

  Conexao.metodo := rmGET;
  Conexao.url := 'pais';
  master := TJSONArray.Create;
  limite := 100;
  offset := 0;

  repeat
    Conexao.AtribuirParametro('limite', IntToStrSenaoZero(limite));
    Conexao.AtribuirParametro('offset', IntToStrSenaoZero(offset));
    Conexao.Enviar;
    continuar := False;
    offset := offset + limite;

    if not (Conexao.status in[200..202]) then
    begin
      informar(Conexao.erro);
      Break;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);
      item := converterJsonValueJsonArray(json, 'dados');
      continuar := json.GetValue<Boolean>('maisRegistros', False);
      copiarItemJsonArray(item, master);
    end;
  until not continuar;

  if (Assigned(master)) and (master.Count > 0) then
  begin
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TPais);
  end
  else
  begin
    TPais.Close;
    TPais.Open;
  end;

  Conexao.Destroy;
end;

function TFDMPais.inativarPais: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
  jsonArray: TJSONArray;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'pais/' + IntToStrSenaoZero(TPaiscodigo.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

end.
