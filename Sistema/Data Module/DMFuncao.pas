unit DMFuncao;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMFuncao = class(TDataModule)
    DFuncao: TDataSource;
    TFuncao: TFDMemTable;
    TFuncaocodigo: TIntegerField;
    TFuncaocadastradoPor: TStringField;
    TFuncaoalteradoPor: TStringField;
    TFuncaodataCadastro: TStringField;
    TFuncaodataAlteracao: TStringField;
    TFuncaostatus: TStringField;
    TFuncaodescricao: TStringField;
    TFuncaovalorHoraNormal: TFloatField;
    TFuncaovalorHora50: TFloatField;
    TFuncaovalorHora100: TFloatField;
    TFuncaovalorAdicionalNoturno: TFloatField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarFuncao: Boolean;
    function alterarFuncao: Boolean;
    function inativarFuncao: Boolean;
  end;

var
  FDMFuncao: TFDMFuncao;

implementation

uses UFuncao, UConexao, Funcao;

{$R *.dfm}

function TFDMFuncao.cadastrarFuncao: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'funcao';
  Conexao.AtribuirBody('descricao', TFuncaodescricao.Value);
  Conexao.AtribuirBody('valorHoraNormal', VirgulaPonto(TFuncaovalorHoraNormal.Value));
  Conexao.AtribuirBody('valorHora50', VirgulaPonto(TFuncaovalorHora50.Value));
  Conexao.AtribuirBody('valorHora100', VirgulaPonto(TFuncaovalorHora100.Value));
  Conexao.AtribuirBody('valorAdicionalNoturno', VirgulaPonto(TFuncaovalorAdicionalNoturno.Value));
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
      TFuncaocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TFuncaocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TFuncaoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TFuncaodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TFuncaodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TFuncaostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMFuncao.alterarFuncao: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'funcao/' + IntToStrSenaoZero(TFuncaocodigo.Value);
  Conexao.AtribuirBody('descricao', TFuncaodescricao.Value);
  Conexao.AtribuirBody('valorHoraNormal', VirgulaPonto(TFuncaovalorHoraNormal.Value));
  Conexao.AtribuirBody('valorHora50', VirgulaPonto(TFuncaovalorHora50.Value));
  Conexao.AtribuirBody('valorHora100', VirgulaPonto(TFuncaovalorHora100.Value));
  Conexao.AtribuirBody('valorAdicionalNoturno', VirgulaPonto(TFuncaovalorAdicionalNoturno.Value));
  Conexao.AtribuirBody('status', TFuncaostatus.Value);
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
      TFuncaocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TFuncaocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TFuncaoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TFuncaodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TFuncaodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TFuncaostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMFuncao.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FFuncao)) then
  begin
    if (FFuncao.ELocalizarDescricao.Text <> '') then
    begin
      Conexao.AtribuirParametro('descricao', FFuncao.ELocalizarDescricao.Text);
    end;

    if FFuncao.CBMostrarInativo.Checked then
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
  Conexao.url := 'funcao';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TFuncao);
  end
  else
  begin
    TFuncao.Close;
    TFuncao.Open;
  end;

  Conexao.Destroy;
end;

function TFDMFuncao.inativarFuncao: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'funcao/' + IntToStrSenaoZero(TFuncaocodigo.Value);
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
