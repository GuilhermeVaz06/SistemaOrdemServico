unit DMClienteFornecedor;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils;

type
  TFDMClienteFornecedor = class(TDataModule)
    DClienteFornecedor: TDataSource;
    TClienteFornecedor: TFDMemTable;
    TClienteFornecedorcodigo: TIntegerField;
    TClienteFornecedorcadastradoPor: TStringField;
    TClienteFornecedoralteradoPor: TStringField;
    TClienteFornecedordataCadastro: TStringField;
    TClienteFornecedordataAlteracao: TStringField;
    TClienteFornecedorstatus: TStringField;
    TClienteFornecedorcodigoTipoDocumento: TIntegerField;
    TClienteFornecedortipoDocumento: TStringField;
    TClienteFornecedorqtdeCaracteres: TIntegerField;
    TClienteFornecedormascaraCaracteres: TStringField;
    TClienteFornecedordocumento: TStringField;
    TClienteFornecedorrazaoSocial: TStringField;
    TClienteFornecedornomeFantasia: TStringField;
    TClienteFornecedortelefone: TStringField;
    TClienteFornecedoremail: TStringField;
    TClienteFornecedorobservacao: TMemoField;
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
    DOutroDocumento: TDataSource;
    TOutroDocumento: TFDMemTable;
    TOutroDocumentocodigoPessoa: TIntegerField;
    TOutroDocumentocodigoTipoDocumento: TIntegerField;
    TOutroDocumentodocumento: TStringField;
    TOutroDocumentoTipoDocumento: TStringField;
    TOutroDocumentodataEmissao: TDateField;
    TOutroDocumentodataVencimento: TDateField;
    TOutroDocumentoobservacao: TMemoField;
    TOutroDocumentocadastradoPor: TStringField;
    TOutroDocumentoalteradoPor: TStringField;
    TOutroDocumentodataCadastro: TStringField;
    TOutroDocumentodataAlteracao: TStringField;
    TOutroDocumentostatus: TStringField;
    TOutroDocumentocodigo: TIntegerField;
    TOutroDocumentomascaraCaracteres: TStringField;
    procedure MemoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClienteFornecedordocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClienteFornecedortelefoneGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClienteFornecedorAfterScroll(DataSet: TDataSet);
    procedure TOutroDocumentodocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private

  public
    tipoCadastro: string;
    dadosPessoaConsultados: Integer;
    procedure consultarDados(codigo: integer);
    function cadastrarClienteFornecedor: Boolean;
    function alterarClienteFornecedor: Boolean;
    function inativarClienteFornecedor: Boolean;
    procedure consultarDadosOutroDocumento(codigo: integer; mostrarErro: Boolean);
    function cadastrarOutroDocumento: Boolean;
    function alterarOutroDocumento: Boolean;
    function inativarOutroDocumento: Boolean;
    procedure consultarTipoDocumento;
  end;

var
  FDMClienteFornecedor: TFDMClienteFornecedor;

implementation

uses UFuncao, UConexao, ClienteFornecedor;

{$R *.dfm}

function TFDMClienteFornecedor.alterarOutroDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'outroDocumento/' + IntToStrSenaoZero(TOutroDocumentocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TOutroDocumentocodigo.Value);
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TOutroDocumentocodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TOutroDocumentodocumento.Value);
  Conexao.AtribuirBody('dataEmissao', DateToStr(TOutroDocumentodataEmissao.Value));
  Conexao.AtribuirBody('dataVencimento', DateToStr(TOutroDocumentodataVencimento.Value));
  Conexao.AtribuirBody('observacao', TOutroDocumentoobservacao.Value);
  Conexao.AtribuirBody('status', TOutroDocumentostatus.Value);
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
      TOutroDocumentocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOutroDocumentoTipoDocumento.Value := json.GetValue<string>('TipoDocumento', '');
      TOutroDocumentomascaraCaracteres.Value := json.GetValue<string>('mascaraCaracteres', '');
      TOutroDocumentocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOutroDocumentoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOutroDocumentodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOutroDocumentodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOutroDocumentostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMClienteFornecedor.cadastrarClienteFornecedor: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := tipoCadastro;
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TClienteFornecedorcodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TClienteFornecedordocumento.Value);
  Conexao.AtribuirBody('razaoSocial', TClienteFornecedorrazaoSocial.Value);
  Conexao.AtribuirBody('nomeFantasia', TClienteFornecedornomeFantasia.Value);
  Conexao.AtribuirBody('telefone', TClienteFornecedortelefone.Value);
  Conexao.AtribuirBody('email', TClienteFornecedoremail.Value);
  Conexao.AtribuirBody('observacao', TClienteFornecedorobservacao.Value);
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
      TClienteFornecedorcodigo.Value := json.GetValue<Integer>('codigo', 0);
      TClienteFornecedorcadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TClienteFornecedoralteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TClienteFornecedordataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TClienteFornecedordataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TClienteFornecedorstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMClienteFornecedor.cadastrarOutroDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'outroDocumento';
  Conexao.AtribuirBody('codigoPessoa', IntToStrSenaoZero(TOutroDocumentocodigoPessoa.Value));
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TOutroDocumentocodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TOutroDocumentodocumento.Value);
  Conexao.AtribuirBody('dataEmissao', DateToStr(TOutroDocumentodataEmissao.Value));
  Conexao.AtribuirBody('dataVencimento', DateToStr(TOutroDocumentodataVencimento.Value));
  Conexao.AtribuirBody('observacao', TOutroDocumentoobservacao.Value);
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
      TOutroDocumentocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOutroDocumentoTipoDocumento.Value := json.GetValue<string>('TipoDocumento', '');
      TOutroDocumentomascaraCaracteres.Value := json.GetValue<string>('mascaraCaracteres', '');
      TOutroDocumentocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOutroDocumentoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOutroDocumentodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOutroDocumentodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOutroDocumentostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMClienteFornecedor.alterarClienteFornecedor: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := tipoCadastro + '/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TClienteFornecedorcodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TClienteFornecedordocumento.Value);
  Conexao.AtribuirBody('razaoSocial', TClienteFornecedorrazaoSocial.Value);
  Conexao.AtribuirBody('nomeFantasia', TClienteFornecedornomeFantasia.Value);
  Conexao.AtribuirBody('telefone', TClienteFornecedortelefone.Value);
  Conexao.AtribuirBody('email', TClienteFornecedoremail.Value);
  Conexao.AtribuirBody('observacao', TClienteFornecedorobservacao.Value);
  Conexao.AtribuirBody('status', TClienteFornecedorstatus.Value);
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
      TClienteFornecedorcodigo.Value := json.GetValue<Integer>('codigo', 0);
      TClienteFornecedorcadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TClienteFornecedoralteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TClienteFornecedordataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TClienteFornecedordataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TClienteFornecedorstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMClienteFornecedor.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FClienteFornecedor)) then
  begin
    if (FClienteFornecedor.ERazaoSocial.Text <> '') then
    begin
      Conexao.AtribuirParametro('razaoSocial', FClienteFornecedor.ERazaoSocial.Text);
    end;

    if (FClienteFornecedor.ENomeFantasia.Text <> '') then
    begin
      Conexao.AtribuirParametro('nomeFantasia', FClienteFornecedor.ENomeFantasia.Text);
    end;

    if FClienteFornecedor.CBMostrarInativo.Checked then
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
  Conexao.url := tipoCadastro;
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TClienteFornecedor);
  end
  else
  begin
    TClienteFornecedor.Close;
    TClienteFornecedor.Open;
  end;

  Conexao.Destroy;
end;

procedure TFDMClienteFornecedor.consultarDadosOutroDocumento(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TClienteFornecedorcodigo.Value > 0) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FClienteFornecedor)) then
    begin
      if FClienteFornecedor.CBInativoOutroDocumento.Checked then
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

    dadosPessoaConsultados := TClienteFornecedorcodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'outroDocumento/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
    master := TJSONArray.Create;
    limite := 500;
    offset := 0;

    repeat
      Conexao.AtribuirParametro('limite', IntToStrSenaoZero(limite));
      Conexao.AtribuirParametro('offset', IntToStrSenaoZero(offset));
      Conexao.Enviar;
      continuar := False;
      offset := offset + limite;

      if not (Conexao.status in[200..202]) and (mostrarErro) then
      begin
        informar(Conexao.erro);
        Break;
      end
      else if (Conexao.status in[200..202]) then
      begin
        json := converterJsonTextoJsonValue(Conexao.resposta);
        item := converterJsonValueJsonArray(json, 'dados');
        continuar := json.GetValue<Boolean>('maisRegistros', False);
        copiarItemJsonArray(item, master);
      end
      else if not (Conexao.status in[200..202]) and (mostrarErro = False) then
      begin
        Break;
      end;
    until not continuar;

    if (Assigned(master)) and (master.Count > 0) then
    begin
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TOutroDocumento);
    end
    else
    begin
      TOutroDocumento.Close;
      TOutroDocumento.Open;
    end;

    Conexao.Destroy;
  end;
end;

function TFDMClienteFornecedor.inativarClienteFornecedor: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := tipoCadastro + '/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
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

function TFDMClienteFornecedor.inativarOutroDocumento: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'outroDocumento/' + IntToStrSenaoZero(TOutroDocumentocodigo.Value);
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

procedure TFDMClienteFornecedor.MemoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

procedure TFDMClienteFornecedor.TClienteFornecedorAfterScroll(
  DataSet: TDataSet);
begin
  if (FClienteFornecedor.PCTela.ActivePage = FClienteFornecedor.TBCadastro) then
  begin
    consultarDadosOutroDocumento(0, False);
  end;
end;

procedure TFDMClienteFornecedor.TClienteFornecedordocumentoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatMaskText(TClienteFornecedormascaraCaracteres.Value, TClienteFornecedordocumento.Value);
end;

procedure TFDMClienteFornecedor.TClienteFornecedortelefoneGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if (Length(TClienteFornecedortelefone.Value) = 12) then
  begin
    Text := FormatMaskText('(999) 9 9999-9999;0', TClienteFornecedortelefone.Value);
  end
  else if (Length(TClienteFornecedortelefone.Value) = 11) then
  begin
    Text := FormatMaskText('(99) 9 9999-9999;0', TClienteFornecedortelefone.Value);
  end
  else if (Length(TClienteFornecedortelefone.Value) = 10) then
  begin
    Text := FormatMaskText('(99) 9999-9999;0', TClienteFornecedortelefone.Value);
  end
  else if (Length(TClienteFornecedortelefone.Value) = 9) then
  begin
    Text := FormatMaskText('9 9999-9999;0', TClienteFornecedortelefone.Value);
  end
  else if (Length(TClienteFornecedortelefone.Value) = 8) then
  begin
    Text := FormatMaskText('9999-9999;0', TClienteFornecedortelefone.Value);
  end
  else
  begin
    Text := TClienteFornecedortelefone.Value;
  end;
end;

procedure TFDMClienteFornecedor.TOutroDocumentodocumentoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText(TOutroDocumentomascaraCaracteres.Value, TOutroDocumentodocumento.Value);
end;

procedure TFDMClienteFornecedor.consultarTipoDocumento;
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
