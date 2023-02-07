unit DMEstado;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMEstado = class(TDataModule)
    DEstado: TDataSource;
    TEstado: TFDMemTable;
    TEstadocodigo: TIntegerField;
    TEstadocodigoPais: TIntegerField;
    TEstadocodigoIbge: TStringField;
    TEstadonome: TStringField;
    TEstadocadastradoPor: TStringField;
    TEstadoalteradoPor: TStringField;
    TEstadodataCadastro: TStringField;
    TEstadodataAlteracao: TStringField;
    TEstadostatus: TStringField;
    TEstadonomePais: TStringField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarEstado: Boolean;
    function alterarEstado: Boolean;
    function inativarEstado: Boolean;
  end;

var
  FDMEstado: TFDMEstado;

implementation

uses UFuncao, UConexao, Estado;

{$R *.dfm}

function TFDMEstado.cadastrarEstado: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'estado';
  Conexao.AtribuirBody('nomeEstado', TEstadonome.Value);
  Conexao.AtribuirBody('codigoPais', IntToStrSenaoZero(TEstadocodigoPais.Value));
  Conexao.AtribuirBody('codigoIBGE', TEstadocodigoIbge.Value);
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
      TEstadocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TEstadocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TEstadoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TEstadodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TEstadodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TEstadostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMEstado.alterarEstado: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'estado/' + IntToStrSenaoZero(TEstadocodigo.Value);
  Conexao.AtribuirBody('nomeEstado', TEstadonome.Value);
  Conexao.AtribuirBody('codigoPais', IntToStrSenaoZero(TEstadocodigoPais.Value));
  Conexao.AtribuirBody('codigoIBGE', TEstadocodigoIbge.Value);
  Conexao.AtribuirBody('status', TEstadostatus.Value);
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
      TEstadocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TEstadocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TEstadoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TEstadodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TEstadodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TEstadostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMEstado.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FEstado)) then
  begin
    if (FEstado.ELocalizarNome.Text <> '') then
    begin
      Conexao.AtribuirParametro('nomeEstado', FEstado.ELocalizarNome.Text);
    end;

    if (FEstado.ELocalizarCodigoIBGE.Text <> '') then
    begin
      Conexao.AtribuirParametro('codigoIBGE', FEstado.ELocalizarCodigoIBGE.Text);
    end;

    if FEstado.CBMostrarInativo.Checked then
    begin
      Conexao.AtribuirParametro('status', 'I');
    end
    else
    begin
      Conexao.AtribuirParametro('status', 'A');
    end;
  end;

  if (codigo > 0) then
  begin
    Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
  end;

  Conexao.metodo := rmGET;
  Conexao.url := 'estado';
  master := TJSONArray.Create;
  limite := 500;
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TEstado);
  end
  else
  begin
    TEstado.Close;
    TEstado.Open;
  end;

  Conexao.Destroy;
end;

function TFDMEstado.inativarEstado: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'estado/' + IntToStrSenaoZero(TEstadocodigo.Value);
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
