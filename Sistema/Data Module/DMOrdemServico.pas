unit DMOrdemServico;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils;

type
  TFDMOrdemServico = class(TDataModule)
    DOrdemServico: TDataSource;
    TOrdemServico: TFDMemTable;
    TOrdemServicocodigo: TIntegerField;
    TOrdemServicocadastradoPor: TStringField;
    TOrdemServicoalteradoPor: TStringField;
    TOrdemServicodataCadastro: TStringField;
    TOrdemServicodataAlteracao: TStringField;
    TOrdemServicoempresaCodigo: TIntegerField;
    TOrdemServicoempresaNome: TStringField;
    TOrdemServicoclienteCodigo: TIntegerField;
    TOrdemServicoclienteNome: TStringField;
    TOrdemServicoenderecoCodigo: TIntegerField;
    TOrdemServicoenderecoTipo: TStringField;
    TOrdemServicoenderecoCEP: TStringField;
    TOrdemServicoenderecoLongradouro: TStringField;
    TOrdemServicoenderecoNumero: TStringField;
    TOrdemServicoenderecoBairro: TStringField;
    TOrdemServicoenderecoComplemento: TStringField;
    TOrdemServicoenderecoObservacao: TMemoField;
    TOrdemServicoenderecoCidade: TStringField;
    TOrdemServicoenderecoEstado: TStringField;
    TOrdemServicoenderecoPais: TStringField;
    TOrdemServicotransportadoraCodigo: TIntegerField;
    TOrdemServicotransportadoraNome: TStringField;
    TOrdemServicofinalidade: TStringField;
    TOrdemServicotipoFrete: TStringField;
    TOrdemServicodetalhamento: TMemoField;
    TOrdemServicosituacao: TStringField;
    TOrdemServicoobservacao: TMemoField;
    TOrdemServicodesconto: TFloatField;
    TOrdemServicostatus: TStringField;
    TOrdemServicodataPrazoEntrega: TStringField;
    TOrdemServicodataOrdemServico: TStringField;
    DEmpresa: TDataSource;
    QEmpresa: TFDMemTable;
    QEmpresacodigo: TIntegerField;
    QEmpresarazaoSocial: TStringField;
    DTipoFrete: TDataSource;
    QTipoFrete: TFDMemTable;
    QTipoFretedescricao: TStringField;
    DFinalidade: TDataSource;
    QFinalidade: TFDMemTable;
    QFinalidadedescricao: TStringField;
    DEndereco: TDataSource;
    QEndereco: TFDMemTable;
    QEnderecocodigo: TIntegerField;
    QEnderecocodigoPessoa: TIntegerField;
    QEnderecocodigoTipoEndereco: TIntegerField;
    QEnderecotipoEndereco: TStringField;
    QEnderecocep: TStringField;
    QEnderecolongradouro: TStringField;
    QEndereconumero: TStringField;
    QEnderecobairro: TStringField;
    QEnderecocomplemento: TStringField;
    QEnderecoobservacao: TMemoField;
    QEnderecocodigoCidade: TIntegerField;
    QEndereconomeCidade: TStringField;
    QEndereconomeEstado: TStringField;
    QEndereconomePais: TStringField;
    QEnderecoprioridade: TStringField;
    QEnderecocadastradoPor: TStringField;
    QEnderecoalteradoPor: TStringField;
    QEnderecodataCadastro: TStringField;
    QEnderecodataAlteracao: TStringField;
    QEnderecostatus: TStringField;
    procedure GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TOrdemServicoAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarOrdemServico: Boolean;
    function alterarOrdemServico: Boolean;
    procedure consultarEmpresa;
    procedure consultarEnderecoCliente;
  end;

var
  FDMOrdemServico: TFDMOrdemServico;

implementation

uses UFuncao, UConexao, OrdemServico;

{$R *.dfm}

function TFDMOrdemServico.cadastrarOrdemServico: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServico';
  Conexao.AtribuirBody('empresaCodigo', IntToStrSenaoZero(TOrdemServicoempresaCodigo.Value));
  Conexao.AtribuirBody('clienteCodigo', IntToStrSenaoZero(TOrdemServicoclienteCodigo.Value));
  Conexao.AtribuirBody('enderecoCodigo', IntToStrSenaoZero(TOrdemServicoenderecoCodigo.Value));
  Conexao.AtribuirBody('transportadoraCodigo', IntToStrSenaoZero(TOrdemServicotransportadoraCodigo.Value));
  Conexao.AtribuirBody('finalidade', TOrdemServicofinalidade.Value);
  Conexao.AtribuirBody('tipoFrete', TOrdemServicotipoFrete.Value);
  Conexao.AtribuirBody('detalhamento', TOrdemServicodetalhamento.Value);
  Conexao.AtribuirBody('observacao', TOrdemServicoobservacao.Value);
  Conexao.AtribuirBody('dataEntrega', TOrdemServicodataPrazoEntrega.Value);
  Conexao.AtribuirBody('dataOrdem', TOrdemServicodataOrdemServico.Value);
  Conexao.AtribuirBody('desconto', VirgulaPonto(TOrdemServicodesconto.Value));
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
      TOrdemServicocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOrdemServicocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOrdemServicoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOrdemServicodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOrdemServicodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOrdemServicostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarOrdemServico: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServico/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
  Conexao.AtribuirBody('empresaCodigo', IntToStrSenaoZero(TOrdemServicoempresaCodigo.Value));
  Conexao.AtribuirBody('clienteCodigo', IntToStrSenaoZero(TOrdemServicoclienteCodigo.Value));
  Conexao.AtribuirBody('enderecoCodigo', IntToStrSenaoZero(TOrdemServicoenderecoCodigo.Value));
  Conexao.AtribuirBody('transportadoraCodigo', IntToStrSenaoZero(TOrdemServicotransportadoraCodigo.Value));
  Conexao.AtribuirBody('finalidade', TOrdemServicofinalidade.Value);
  Conexao.AtribuirBody('tipoFrete', TOrdemServicotipoFrete.Value);
  Conexao.AtribuirBody('detalhamento', TOrdemServicodetalhamento.Value);
  Conexao.AtribuirBody('observacao', TOrdemServicoobservacao.Value);
  Conexao.AtribuirBody('dataEntrega', TOrdemServicodataPrazoEntrega.Value);
  Conexao.AtribuirBody('dataOrdem', TOrdemServicodataOrdemServico.Value);
  Conexao.AtribuirBody('desconto', VirgulaPonto(TOrdemServicodesconto.Value));
  Conexao.AtribuirBody('status', TOrdemServicostatus.Value);
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
      TOrdemServicocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOrdemServicocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOrdemServicoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOrdemServicodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOrdemServicodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOrdemServicostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FOrdemServico)) then
  begin
    if FOrdemServico.CBMostrarInativo.Checked then
    begin
      Conexao.AtribuirParametro('status', 'I');
    end
    else
    begin
      Conexao.AtribuirParametro('status', 'A');
    end;

    if (FOrdemServico.DBLConsultaEmpresa.Text <> '') then
    begin
      Conexao.AtribuirParametro('empresaCodigo', IntToStrSenaoZero(FOrdemServico.DBLConsultaEmpresa.KeyValue));
    end;
  end;

  if (codigo > 0) then
  begin
    Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
  end;

  Conexao.metodo := rmGET;
  Conexao.url := 'ordemServico';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TOrdemServico);
  end
  else
  begin
    TOrdemServico.Close;
    TOrdemServico.Open;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.consultarEmpresa;
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  Conexao.AtribuirParametro('status', 'A');
  Conexao.metodo := rmGET;
  Conexao.url := 'empresa';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), QEmpresa);
  end
  else
  begin
    QEmpresa.Close;
    QEmpresa.Open;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.consultarEnderecoCliente;
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TOrdemServicoclienteCodigo.Value > 0) then
  begin
    Conexao := TConexao.Create;
    Conexao.AtribuirParametro('status', 'A');
    Conexao.metodo := rmGET;
    Conexao.url := 'endereco/' + IntToStrSenaoZero(TOrdemServicoclienteCodigo.Value);
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
      else if (Conexao.status in[200..202]) then
      begin
        json := converterJsonTextoJsonValue(Conexao.resposta);
        item := converterJsonValueJsonArray(json, 'dados');
        continuar := json.GetValue<Boolean>('maisRegistros', False);
        copiarItemJsonArray(item, master);
      end;
    until not continuar;

    if (Assigned(master)) and (master.Count > 0) then
    begin
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), QEndereco);
    end
    else
    begin
      QEndereco.Close;
      QEndereco.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMOrdemServico.DataModuleCreate(Sender: TObject);
var
  jsonArrayTipoFrete, jsonArrayFinalidade: TJSONArray;
  json: TJSONObject;
begin
  jsonArrayTipoFrete := TJSONArray.Create;

  json := TJSONObject.Create;
  json.AddPair('descricao', 'CIF');

  jsonArrayTipoFrete.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'FOB');

  jsonArrayTipoFrete.Add(json);

  converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArrayTipoFrete), QTipoFrete);
  QTipoFrete.Active;

  jsonArrayFinalidade := TJSONArray.Create;

  json := TJSONObject.Create;
  json.AddPair('descricao', 'REPARO');

  jsonArrayFinalidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'INSTALAÇÃO');

  jsonArrayFinalidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'MANUTENÇÃO');

  json := TJSONObject.Create;
  json.AddPair('descricao', 'CONSTRUÇÃO');

  jsonArrayFinalidade.Add(json);

  converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArrayFinalidade), QFinalidade);
  QFinalidade.Active;
end;

procedure TFDMOrdemServico.GetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

procedure TFDMOrdemServico.TOrdemServicoAfterScroll(DataSet: TDataSet);
begin
  if (Assigned(FOrdemServico)) and
     (FOrdemServico.PCTela.ActivePage = FOrdemServico.TBCadastro) and
     (TOrdemServico.RecordCount > 0) then
  begin
    if (TOrdemServicodataOrdemServico.Value <> '') then
    begin
      FOrdemServico.DBDataOrdem.Date := StrToDate(TOrdemServicodataOrdemServico.Value);
    end;

    if (TOrdemServicodataPrazoEntrega.Value <> '') then
    begin
      FOrdemServico.DBPrazoEntrega.Date := StrToDate(TOrdemServicodataPrazoEntrega.Value);
    end;
  end;
end;

end.
