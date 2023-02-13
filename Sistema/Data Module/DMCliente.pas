unit DMCliente;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils;

type
  TFDMCliente = class(TDataModule)
    DCliente: TDataSource;
    TCliente: TFDMemTable;
    TClientecodigo: TIntegerField;
    TClientecadastradoPor: TStringField;
    TClientealteradoPor: TStringField;
    TClientedataCadastro: TStringField;
    TClientedataAlteracao: TStringField;
    TClientestatus: TStringField;
    TClientecodigoTipoDocumento: TIntegerField;
    TClientetipoDocumento: TStringField;
    TClienteqtdeCaracteres: TIntegerField;
    TClientemascaraCaracteres: TStringField;
    TClientedocumento: TStringField;
    TClienterazaoSocial: TStringField;
    TClientenomeFantasia: TStringField;
    TClientetelefone: TStringField;
    TClienteemail: TStringField;
    TClienteobservacao: TMemoField;
    DTipoDocumento: TDataSource;
    QTipoDocumento: TFDMemTable;
    QTipoDocumentocodigo: TIntegerField;
    QTipoDocumentodescricao: TStringField;
    QTipoDocumentoqtdeCaracteres: TIntegerField;
    QTipoDocumentomascara: TStringField;
    QTipoDocumentostatus: TStringField;
    QTipoDocumentocadastradoPor: TStringField;
    QTipoDocumentoalteradoPor: TStringField;
    QTipoDocumentodataCadastro: TStringField;
    QTipoDocumentodataAlteracao: TStringField;
    procedure MemoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClientedocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClientetelefoneGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarCliente: Boolean;
    function alterarCliente: Boolean;
    function inativarCliente: Boolean;
    procedure consultarTipoDocumento;
  end;

var
  FDMCliente: TFDMCliente;

implementation

uses UFuncao, UConexao, Cliente;

{$R *.dfm}

function TFDMCliente.cadastrarCliente: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'cliente';
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TClientecodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TClientedocumento.Value);
  Conexao.AtribuirBody('razaoSocial', TClienterazaoSocial.Value);
  Conexao.AtribuirBody('nomeFantasia', TClientenomeFantasia.Value);
  Conexao.AtribuirBody('telefone', TClientetelefone.Value);
  Conexao.AtribuirBody('email', TClienteemail.Value);
  Conexao.AtribuirBody('observacao', TClienteobservacao.Value);
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
      TClientecodigo.Value := json.GetValue<Integer>('codigo', 0);
      TClientecadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TClientealteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TClientedataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TClientedataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TClientestatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMCliente.alterarCliente: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'cliente/' + IntToStrSenaoZero(TClientecodigo.Value);
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TClientecodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TClientedocumento.Value);
  Conexao.AtribuirBody('razaoSocial', TClienterazaoSocial.Value);
  Conexao.AtribuirBody('nomeFantasia', TClientenomeFantasia.Value);
  Conexao.AtribuirBody('telefone', TClientetelefone.Value);
  Conexao.AtribuirBody('email', TClienteemail.Value);
  Conexao.AtribuirBody('observacao', TClienteobservacao.Value);
  Conexao.AtribuirBody('status', TClientestatus.Value);
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
      TClientecodigo.Value := json.GetValue<Integer>('codigo', 0);
      TClientecadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TClientealteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TClientedataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TClientedataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TClientestatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMCliente.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FCliente)) then
  begin
    if (FCliente.ELocalizarDescricao.Text <> '') then
    begin
      Conexao.AtribuirParametro('nomeFantasia', FCliente.ELocalizarDescricao.Text);
    end;

    if FCliente.CBMostrarInativo.Checked then
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
  Conexao.url := 'cliente';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TCliente);
  end
  else
  begin
    TCliente.Close;
    TCliente.Open;
  end;

  Conexao.Destroy;
end;

function TFDMCliente.inativarCliente: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'cliente/' + IntToStrSenaoZero(TClientecodigo.Value);
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

procedure TFDMCliente.MemoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

procedure TFDMCliente.TClientedocumentoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatMaskText(TClientemascaraCaracteres.Value, TClientedocumento.Value);
end;

procedure TFDMCliente.TClientetelefoneGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if (Length(TClientetelefone.Value) = 12) then
  begin
    Text := FormatMaskText('(999) 9 9999-9999;0', TClientetelefone.Value);
  end
  else if (Length(TClientetelefone.Value) = 11) then
  begin
    Text := FormatMaskText('(99) 9 9999-9999;0', TClientetelefone.Value);
  end
  else if (Length(TClientetelefone.Value) = 10) then
  begin
    Text := FormatMaskText('(99) 9999-9999;0', TClientetelefone.Value);
  end
  else if (Length(TClientetelefone.Value) = 9) then
  begin
    Text := FormatMaskText('9 9999-9999;0', TClientetelefone.Value);
  end
  else if (Length(TClientetelefone.Value) = 8) then
  begin
    Text := FormatMaskText('9999-9999;0', TClientetelefone.Value);
  end
  else
  begin
    Text := TClientetelefone.Value;
  end;
end;

procedure TFDMCliente.consultarTipoDocumento;
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmGET;
  Conexao.url := 'tipoDocumento';
  master := TJSONArray.Create;
  limite := 50;
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), QTipoDocumento);
  end
  else
  begin
    QTipoDocumento.Close;
    QTipoDocumento.Open;
  end;

  Conexao.Destroy;
end;

end.
