unit DMTipoDocumento;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMTipoDocumento = class(TDataModule)
    DTipoDocumento: TDataSource;
    TTipoDocumento: TFDMemTable;
    TTipoDocumentocodigo: TIntegerField;
    TTipoDocumentocadastradoPor: TStringField;
    TTipoDocumentoalteradoPor: TStringField;
    TTipoDocumentodataCadastro: TStringField;
    TTipoDocumentodataAlteracao: TStringField;
    TTipoDocumentostatus: TStringField;
    TTipoDocumentodescricao: TStringField;
    TTipoDocumentoqtdeCaracteres: TIntegerField;
    TTipoDocumentomascara: TStringField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarTipoDocumento: Boolean;
    function alterarTipoDocumento: Boolean;
    function inativarTipoDocumento: Boolean;
  end;

var
  FDMTipoDocumento: TFDMTipoDocumento;

implementation

uses UFuncao, UConexao, TipoDocumento;

{$R *.dfm}

function TFDMTipoDocumento.cadastrarTipoDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'tipoDocumento';
  Conexao.AtribuirBody('descricao', TTipoDocumentodescricao.Value);
  Conexao.AtribuirBody('qtdeCaracteres', IntToStrSenaoZero(TTipoDocumentoqtdeCaracteres.Value));
  Conexao.AtribuirBody('mascara', TTipoDocumentomascara.Value);
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
      TTipoDocumentocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TTipoDocumentocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TTipoDocumentoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TTipoDocumentodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TTipoDocumentodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TTipoDocumentostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMTipoDocumento.alterarTipoDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'tipoDocumento/' + IntToStrSenaoZero(TTipoDocumentocodigo.Value);
  Conexao.AtribuirBody('descricao', TTipoDocumentodescricao.Value);
  Conexao.AtribuirBody('qtdeCaracteres', IntToStrSenaoZero(TTipoDocumentoqtdeCaracteres.Value));
  Conexao.AtribuirBody('mascara', TTipoDocumentomascara.Value);
  Conexao.AtribuirBody('status', TTipoDocumentostatus.Value);
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
      TTipoDocumentocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TTipoDocumentocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TTipoDocumentoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TTipoDocumentodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TTipoDocumentodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TTipoDocumentostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMTipoDocumento.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FTipoDocumento)) then
  begin
    if (FTipoDocumento.ELocalizarDescricao.Text <> '') then
    begin
      Conexao.AtribuirParametro('descricao', FTipoDocumento.ELocalizarDescricao.Text);
    end;

    if FTipoDocumento.CBMostrarInativo.Checked then
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
  Conexao.url := 'tipoDocumento';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TTipoDocumento);
  end
  else
  begin
    TTipoDocumento.Close;
    TTipoDocumento.Open;
  end;

  Conexao.Destroy;
end;

function TFDMTipoDocumento.inativarTipoDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'tipoDocumento/' + IntToStrSenaoZero(TTipoDocumentocodigo.Value);
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
