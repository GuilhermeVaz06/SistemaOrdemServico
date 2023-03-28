unit DMOrdemServico;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils, VCL.Graphics, Access2010;

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
    DItem: TDataSource;
    TItem: TFDMemTable;
    DProduto: TDataSource;
    TProduto: TFDMemTable;
    TItemcodigo: TIntegerField;
    TItemordem: TIntegerField;
    TItemdescricao: TStringField;
    TItemquantidade: TFloatField;
    TItemvalorUnitario: TFloatField;
    TItemvalorTotal: TFloatField;
    TItemdesconto: TFloatField;
    TItemvalorDesconto: TFloatField;
    TItemvalorFinal: TFloatField;
    TItemcadastradoPor: TStringField;
    TItemalteradoPor: TStringField;
    TItemdataCadastro: TStringField;
    TItemdataAlteracao: TStringField;
    TItemstatus: TStringField;
    TProdutocodigo: TIntegerField;
    TProdutoordem: TIntegerField;
    TProdutodescricao: TStringField;
    TProdutounidade: TStringField;
    TProdutoquantidade: TFloatField;
    TProdutovalorUnitario: TFloatField;
    TProdutovalorTotal: TFloatField;
    TProdutodesconto: TFloatField;
    TProdutovalorDesconto: TFloatField;
    TProdutovalorFinal: TFloatField;
    TProdutocadastradoPor: TStringField;
    TProdutoalteradoPor: TStringField;
    TProdutodataCadastro: TStringField;
    TProdutodataAlteracao: TStringField;
    TProdutostatus: TStringField;
    DUnidade: TDataSource;
    QUnidade: TFDMemTable;
    QUnidadedescricao: TStringField;
    TOrdemServicovalorTotalItem: TFloatField;
    TOrdemServicovalorDescontoItem: TFloatField;
    TOrdemServicovalorFinalItem: TFloatField;
    TOrdemServicovalorTotalProduto: TFloatField;
    TOrdemServicovalorDescontoProduto: TFloatField;
    TOrdemServicovalorFinalProduto: TFloatField;
    TOrdemServicovalorFinal: TFloatField;
    TOrdemServicovalorDescontoTotal: TFloatField;
    TOrdemServicovalorTotal: TFloatField;
    DCusto: TDataSource;
    TCusto: TFDMemTable;
    TCustocodigo: TIntegerField;
    TCustoordem: TIntegerField;
    TCustocodigoGrupo: TIntegerField;
    TCustodescricao: TStringField;
    TCustosubDescricao: TStringField;
    TCustoquantidade: TFloatField;
    TCustovalorUnitario: TFloatField;
    TCustovalorTotal: TFloatField;
    TCustocadastradoPor: TStringField;
    TCustoalteradoPor: TStringField;
    TCustodataCadastro: TStringField;
    TCustodataAlteracao: TStringField;
    TCustostatus: TStringField;
    DFuncionario: TDataSource;
    TFuncionario: TFDMemTable;
    TFuncionariocodigo: TIntegerField;
    TFuncionarioordem: TIntegerField;
    TFuncionariocodigoFuncao: TIntegerField;
    TFuncionariodescricao: TStringField;
    TFuncionariocodigoFuncionario: TIntegerField;
    TFuncionarionomeFuncionario: TStringField;
    TFuncionarioqtdeHoraNormal: TIntegerField;
    TFuncionarioqtdeHora50: TIntegerField;
    TFuncionarioqtdeHora100: TIntegerField;
    TFuncionarioqtdeHoraAdNoturno: TIntegerField;
    TFuncionariovalorHoraNormal: TFloatField;
    TFuncionariovalorHora50: TFloatField;
    TFuncionariovalorHora100: TFloatField;
    TFuncionariovalorHoraAdNoturno: TFloatField;
    TFuncionariovalorTotalNormal: TFloatField;
    TFuncionariovalorTotal50: TFloatField;
    TFuncionariovalorTotal100: TFloatField;
    TFuncionariovalorTotalAdNoturno: TFloatField;
    TFuncionariovalorTotal: TFloatField;
    TFuncionariocadastradoPor: TStringField;
    TFuncionarioalteradoPor: TStringField;
    TFuncionariodataCadastro: TStringField;
    TFuncionariodataAlteracao: TStringField;
    TFuncionariostatus: TStringField;
    TOrdemServicovalorTotalCusto: TFloatField;
    TOrdemServicovalorTotalCustoFuncionario: TFloatField;
    TOrdemServicovalorLucro: TFloatField;
    TOrdemServicovalorFinalCusto: TFloatField;
    TOrdemServicovalorLucroPercentual: TFloatField;
    QValorTotal: TFDMemTable;
    DValorTotal: TDataSource;
    QValorTotaldescricao: TStringField;
    QValorTotalvalorBruto: TFloatField;
    QValorTotaldesconto: TFloatField;
    QValorTotalvalorFinal: TFloatField;
    QCustoTotal: TFDMemTable;
    DCustoTotal: TDataSource;
    QCustoTotaldescricao: TStringField;
    QCustoTotalsubDescricao: TStringField;
    QCustoTotalquantidade: TFloatField;
    QCustoTotalvalorTotal: TFloatField;
    procedure GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TOrdemServicoAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    dadosOrdemConsultados: integer;
    procedure consultarDados(codigo: integer);
    function cadastrarOrdemServico: Boolean;
    function alterarOrdemServico: Boolean;
    procedure consultarEmpresa;
    procedure consultarEnderecoCliente;
    procedure consultarDadosItem(codigo: integer; mostrarErro: Boolean);
    procedure consultarDadosProduto(codigo: integer; mostrarErro: Boolean);
    procedure consultarDadosCusto(codigo: integer; mostrarErro: Boolean);
    procedure consultarDadosFuncionario(codigo: integer; mostrarErro: Boolean);
    function alterarItem: Boolean;
    function alterarProduto: Boolean;
    function alterarFuncionario: Boolean;
    function alterarCusto: Boolean;
    function cadastrarItem: Boolean;
    function cadastrarProduto: Boolean;
    function cadastrarCusto: Boolean;
    function cadastrarFuncionario: Boolean;
    function inativarItem: Boolean;
    function inativarProduto: Boolean;
    function inativarCusto: Boolean;
    function inativarFuncionario: Boolean;
    function excluirOrdem: Boolean;
    procedure replicarOrdem;
    procedure carregarAbaResumo;
  end;

var
  FDMOrdemServico: TFDMOrdemServico;

implementation

uses UFuncao, UConexao, OrdemServico;

{$R *.dfm}

function TFDMOrdemServico.inativarProduto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'ordemServicoProduto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TProdutocodigo.Value);
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

procedure TFDMOrdemServico.replicarOrdem;
var
  codigo: integer;
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
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar('Erro ao replicar registro, contate o suporte!'
    +#13#10+ Conexao.erro
    );
    Exit;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      codigo := json.GetValue<Integer>('codigo', 0);
    end
    else
    begin
      informar('Erro ao replicar registro, contate o suporte!');
      Exit;
    end;
  end;

  Conexao.Destroy;

  if Assigned(FOrdemServico) then
  begin
    FOrdemServico.CBInativoProduto.Checked := False;
    FOrdemServico.CBMostrarInativoItem.Checked := False;
    FOrdemServico.CBInativoCusto.Checked := False;
    FOrdemServico.CBInativoFuncionario.Checked := False;
  end;

  consultarDadosProduto(0, False);
  consultarDadosItem(0, False);
  consultarDadosCusto(0, False);
  consultarDadosFuncionario(0, False);

  TProduto.First;
  while not TProduto.Eof do
  begin
    Conexao := TConexao.Create;

    Conexao.metodo := rmPOST;
    Conexao.url := 'ordemServicoProduto';
    Conexao.AtribuirBody('ordem', IntToStrSenaoZero(codigo));
    Conexao.AtribuirBody('descricao', TProdutodescricao.Value);
    Conexao.AtribuirBody('unidade', TProdutounidade.Value);
    Conexao.AtribuirBody('quantidade', VirgulaPonto(TProdutoquantidade.Value));
    Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TProdutovalorUnitario.Value));
    Conexao.AtribuirBody('desconto', VirgulaPonto(TProdutodesconto.Value));
    Conexao.Enviar;

    if not (Conexao.status in[200..202]) then
    begin
      informar('Erro ao replicar registro, contate o suporte!'
      +#13#10+ Conexao.erro
      );
      Exit;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);

      if (Assigned(json)) then
      begin
//      nao faz nada pois conseguiu cadastrar com sucesso o produto
      end
      else
      begin
        informar('Erro ao replicar registro dos produtos, contate o suporte!');
        Exit;
      end;
    end;

    Conexao.Destroy;

    TProduto.Next;
  end;

  TItem.First;
  while not TItem.Eof do
  begin
    Conexao := TConexao.Create;

    Conexao.metodo := rmPOST;
    Conexao.url := 'ordemServicoItem';
    Conexao.AtribuirBody('ordem', IntToStrSenaoZero(codigo));
    Conexao.AtribuirBody('descricao', TItemdescricao.Value);
    Conexao.AtribuirBody('quantidade', VirgulaPonto(TItemquantidade.Value));
    Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TItemvalorUnitario.Value));
    Conexao.AtribuirBody('desconto', VirgulaPonto(TItemdesconto.Value));
    Conexao.Enviar;

    if not (Conexao.status in[200..202]) then
    begin
      informar('Erro ao replicar registro, contate o suporte!'
      +#13#10+ Conexao.erro
      );
      Exit;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);

      if (Assigned(json)) then
      begin
//      nao faz nada pois conseguiu cadastrar com sucesso o produto
      end
      else
      begin
        informar('Erro ao replicar registro dos Serviços, contate o suporte!');
        Exit;
      end;
    end;

    Conexao.Destroy;

    TItem.Next;
  end;

  TCusto.First;
  while not TCusto.Eof do
  begin
    Conexao := TConexao.Create;

    Conexao.metodo := rmPOST;
    Conexao.url := 'ordemServicoCusto';
    Conexao.AtribuirBody('ordem', IntToStrSenaoZero(codigo));
    Conexao.AtribuirBody('codigoGrupo', IntToStrSenaoZero(TCustocodigoGrupo.Value));
    Conexao.AtribuirBody('quantidade', VirgulaPonto(TCustoquantidade.Value));
    Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TCustovalorUnitario.Value));
    Conexao.Enviar;

    if not (Conexao.status in[200..202]) then
    begin
      informar('Erro ao replicar registro, contate o suporte!'
      +#13#10+ Conexao.erro
      );
      Exit;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);

      if (Assigned(json)) then
      begin
//      nao faz nada pois conseguiu cadastrar com sucesso o produto
      end
      else
      begin
        informar('Erro ao replicar registro dos custos, contate o suporte!');
        Exit;
      end;
    end;

    Conexao.Destroy;

    TCusto.Next;
  end;

  TFuncionario.First;
  while not TFuncionario.Eof do
  begin
    Conexao := TConexao.Create;

    Conexao.metodo := rmPOST;
    Conexao.url := 'ordemServicoFuncionario';
    Conexao.AtribuirBody('ordem', IntToStrSenaoZero(codigo));
    Conexao.AtribuirBody('codigoFuncao', IntToStrSenaoZero(TFuncionariocodigoFuncao.Value));
    Conexao.AtribuirBody('codigoFuncionario', IntToStrSenaoZero(TFuncionariocodigoFuncionario.Value));
    Conexao.AtribuirBody('qtdeHoraNormal', VirgulaPonto(TFuncionarioqtdeHoraNormal.Value));
    Conexao.AtribuirBody('qtdeHora50', VirgulaPonto(TFuncionarioqtdeHora50.Value));
    Conexao.AtribuirBody('qtdeHora100', VirgulaPonto(TFuncionarioqtdeHora100.Value));
    Conexao.AtribuirBody('qtdeHoraAdNoturno', VirgulaPonto(TFuncionarioqtdeHoraAdNoturno.Value));
    Conexao.AtribuirBody('valorHoraNormal', VirgulaPonto(TFuncionariovalorHoraNormal.Value));
    Conexao.Enviar;

    if not (Conexao.status in[200..202]) then
    begin
      informar('Erro ao replicar registro, contate o suporte!'
      +#13#10+ Conexao.erro
      );
      Exit;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);

      if (Assigned(json)) then
      begin
//      nao faz nada pois conseguiu cadastrar com sucesso o produto
      end
      else
      begin
        informar('Erro ao replicar registro dos funcionarios, contate o suporte!');
        Exit;
      end;
    end;

    Conexao.Destroy;

    TFuncionario.Next;
  end;

  if Assigned(FOrdemServico) then
  begin
    FOrdemServico.EDetalhamento.Text := '';
    FOrdemServico.DBLEmpresa.KeyValue := 0;
  end;

  consultarDados(codigo);

  if (TOrdemServico.RecordCount > 0) and
     (TOrdemServico.Locate('codigo', codigo, [loCaseInsensitive])) then
  begin
    if Assigned(FOrdemServico) then
    begin
      FOrdemServico.BAlterarClick(nil);
    end;

    informar('Ordem de serviço replicada com sucesso!');
  end
  else
  begin
    informar('Erro ao replicar ordem, contate o suporte!');
  end;
end;

function TFDMOrdemServico.inativarItem: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'ordemServicoItem/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TItemcodigo.Value);
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

function TFDMOrdemServico.inativarCusto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'ordemServicoCusto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TCustocodigo.Value);
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

function TFDMOrdemServico.inativarFuncionario: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'ordemServicoFuncionario/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TFuncionariocodigo.Value);
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

function TFDMOrdemServico.cadastrarProduto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServicoProduto';
  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('descricao', TProdutodescricao.Value);
  Conexao.AtribuirBody('unidade', TProdutounidade.Value);
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TProdutoquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TProdutovalorUnitario.Value));
  Conexao.AtribuirBody('desconto', VirgulaPonto(TProdutodesconto.Value));
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
      TProdutocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TProdutocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TProdutovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TProdutovalorDesconto.Value := json.GetValue<Double>('valorDesconto', 0);
      TProdutovalorFinal.Value := json.GetValue<Double>('valorFinal', 0);
      TProdutoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TProdutodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TProdutodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TProdutostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.carregarAbaResumo;
var
  jsonArrayValoresTotais: TJSONArray;
  json: TJSONObject;
  Conexao: TConexao;
  master, item: TJSONArray;
  jsonDados: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (Assigned(FOrdemServico)) and
     (FOrdemServico.PCTela.ActivePage = FOrdemServico.TBCadastro) and
     (TOrdemServico.RecordCount > 0) then
  begin
    if (QValorTotal.Active) then
    begin
      QValorTotal.Close;
    end;

    jsonArrayValoresTotais := TJSONArray.Create;

    json := TJSONObject.Create;
    json.AddPair('descricao', 'Serviço');
    json.AddPair('valorBruto', TJSONNumber.Create(TOrdemServicovalorTotalItem.Value));
    json.AddPair('desconto', TJSONNumber.Create(TOrdemServicovalorDescontoItem.Value));
    json.AddPair('valorFinal', TJSONNumber.Create(TOrdemServicovalorFinalItem.Value));

    jsonArrayValoresTotais.Add(json);

    json := TJSONObject.Create;
    json.AddPair('descricao', 'Produto');
    json.AddPair('valorBruto', TJSONNumber.Create(TOrdemServicovalorTotalProduto.Value));
    json.AddPair('desconto', TJSONNumber.Create(TOrdemServicovalorDescontoProduto.Value));
    json.AddPair('valorFinal', TJSONNumber.Create(TOrdemServicovalorFinalProduto.Value));

    jsonArrayValoresTotais.Add(json);

    json := TJSONObject.Create;
    json.AddPair('descricao', 'Total');
    json.AddPair('valorBruto', TJSONNumber.Create(TOrdemServicovalorTotal.Value));
    json.AddPair('desconto', TJSONNumber.Create(TOrdemServicovalorDescontoTotal.Value));
    json.AddPair('valorFinal', TJSONNumber.Create(TOrdemServicovalorFinal.Value));

    jsonArrayValoresTotais.Add(json);

    converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArrayValoresTotais), QValorTotal);
    QValorTotal.Active;

    Conexao := TConexao.Create;

    Conexao.metodo := rmGET;
    Conexao.url := 'ordemServicoCustoAgrupado/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
    master := TJSONArray.Create;
    limite := 500;
    offset := 0;

    Conexao.AtribuirParametro('limite', IntToStrSenaoZero(limite));
    Conexao.AtribuirParametro('offset', IntToStrSenaoZero(offset));
    Conexao.Enviar;
    continuar := False;
    offset := offset + limite;

    if not (Conexao.status in[200..202]) then
    begin
      informar(Conexao.erro);
    end
    else if (Conexao.status in[200..202]) then
    begin
      jsonDados := converterJsonTextoJsonValue(Conexao.resposta);
      item := converterJsonValueJsonArray(jsonDados, 'dados');
      copiarItemJsonArray(item, master);
    end;

    if (Assigned(master)) and (master.Count > 0) then
    begin
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), QCustoTotal);
    end
    else
    begin
      QCustoTotal.Close;
      QCustoTotal.Open;
    end;

    Conexao.Destroy;
  end;
end;

function TFDMOrdemServico.cadastrarItem: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServicoItem';
  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('descricao', TItemdescricao.Value);
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TItemquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TItemvalorUnitario.Value));
  Conexao.AtribuirBody('desconto', VirgulaPonto(TItemdesconto.Value));
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
      TItemcodigo.Value := json.GetValue<Integer>('codigo', 0);
      TItemcadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TItemvalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TItemvalorDesconto.Value := json.GetValue<Double>('valorDesconto', 0);
      TItemvalorFinal.Value := json.GetValue<Double>('valorFinal', 0);
      TItemalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TItemdataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TItemdataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TItemstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.cadastrarCusto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServicoCusto';
  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('codigoGrupo', IntToStrSenaoZero(TCustocodigoGrupo.Value));
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TCustoquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TCustovalorUnitario.Value));
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
      TCustocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TCustocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TCustovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TCustoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TCustodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TCustodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TCustostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.cadastrarFuncionario: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServicoFuncionario';
  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('codigoFuncao', IntToStrSenaoZero(TFuncionariocodigoFuncao.Value));
  Conexao.AtribuirBody('codigoFuncionario', IntToStrSenaoZero(TFuncionariocodigoFuncionario.Value));
  Conexao.AtribuirBody('qtdeHoraNormal', VirgulaPonto(TFuncionarioqtdeHoraNormal.Value));
  Conexao.AtribuirBody('qtdeHora50', VirgulaPonto(TFuncionarioqtdeHora50.Value));
  Conexao.AtribuirBody('qtdeHora100', VirgulaPonto(TFuncionarioqtdeHora100.Value));
  Conexao.AtribuirBody('qtdeHoraAdNoturno', VirgulaPonto(TFuncionarioqtdeHoraAdNoturno.Value));
  Conexao.AtribuirBody('valorHoraNormal', VirgulaPonto(TFuncionariovalorHoraNormal.Value));
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
      TFuncionariocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TFuncionariocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TFuncionariovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TFuncionarioalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TFuncionariodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TFuncionariodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TFuncionariostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarProduto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServicoProduto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TProdutocodigo.Value);

  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('descricao', TProdutodescricao.Value);
  Conexao.AtribuirBody('unidade', TProdutounidade.Value);
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TProdutoquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TProdutovalorUnitario.Value));
  Conexao.AtribuirBody('desconto', VirgulaPonto(TProdutodesconto.Value));
  Conexao.AtribuirBody('status', TProdutostatus.Value);
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
      TProdutocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TProdutocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TProdutovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TProdutovalorDesconto.Value := json.GetValue<Double>('valorDesconto', 0);
      TProdutovalorFinal.Value := json.GetValue<Double>('valorFinal', 0);
      TProdutoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TProdutodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TProdutodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TProdutostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarItem: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServicoItem/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TItemcodigo.Value);

  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('descricao', TItemdescricao.Value);
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TItemquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TItemvalorUnitario.Value));
  Conexao.AtribuirBody('desconto', VirgulaPonto(TItemdesconto.Value));
  Conexao.AtribuirBody('status', TItemstatus.Value);
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
      TItemcodigo.Value := json.GetValue<Integer>('codigo', 0);
      TItemcadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TItemvalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TItemvalorDesconto.Value := json.GetValue<Double>('valorDesconto', 0);
      TItemvalorFinal.Value := json.GetValue<Double>('valorFinal', 0);
      TItemalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TItemdataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TItemdataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TItemstatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarCusto: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServicoCusto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TCustocodigo.Value);

  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('codigoGrupo', IntToStrSenaoZero(TCustocodigoGrupo.Value));
  Conexao.AtribuirBody('quantidade', VirgulaPonto(TCustoquantidade.Value));
  Conexao.AtribuirBody('valorUnitario', VirgulaPonto(TCustovalorUnitario.Value));
  Conexao.AtribuirBody('status', TCustostatus.Value);
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
      TCustocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TCustocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TCustovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TCustoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TCustodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TCustodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TCustostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarFuncionario: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServicoFuncionario/' + IntToStrSenaoZero(TOrdemServicocodigo.Value) +
                 '/' + IntToStrSenaoZero(TFuncionariocodigo.Value);

  Conexao.AtribuirBody('ordem', IntToStrSenaoZero(TOrdemServicocodigo.Value));
  Conexao.AtribuirBody('codigoFuncao', IntToStrSenaoZero(TFuncionariocodigoFuncao.Value));
  Conexao.AtribuirBody('codigoFuncionario', IntToStrSenaoZero(TFuncionariocodigoFuncionario.Value));
  Conexao.AtribuirBody('qtdeHoraNormal', VirgulaPonto(TFuncionarioqtdeHoraNormal.Value));
  Conexao.AtribuirBody('qtdeHora50', VirgulaPonto(TFuncionarioqtdeHora50.Value));
  Conexao.AtribuirBody('qtdeHora100', VirgulaPonto(TFuncionarioqtdeHora100.Value));
  Conexao.AtribuirBody('qtdeHoraAdNoturno', VirgulaPonto(TFuncionarioqtdeHoraAdNoturno.Value));
  Conexao.AtribuirBody('valorHoraNormal', VirgulaPonto(TFuncionariovalorHoraNormal.Value));
  Conexao.AtribuirBody('status', TFuncionariostatus.Value);
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
      TFuncionariocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TFuncionariocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TFuncionariovalorTotal.Value := json.GetValue<Double>('valorTotal', 0);
      TFuncionarioalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TFuncionariodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TFuncionariodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TFuncionariostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.consultarDadosProduto(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TOrdemServicocodigo.Value > 0) or (TOrdemServico.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (codigo > 0) then
    begin
      Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
    end;

    if (Assigned(FOrdemServico)) then
    begin
      if FOrdemServico.CBInativoProduto.Checked then
      begin
        Conexao.AtribuirParametro('status', 'I');
      end
      else
      begin
        Conexao.AtribuirParametro('status', 'A');
      end;
    end;

    dadosOrdemConsultados := TOrdemServicocodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'ordemServicoProduto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TProduto);
    end
    else
    begin
      TProduto.Close;
      TProduto.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMOrdemServico.consultarDadosCusto(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TOrdemServicocodigo.Value > 0) or (TOrdemServico.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (codigo > 0) then
    begin
      Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
    end;

    if (Assigned(FOrdemServico)) then
    begin
      if FOrdemServico.CBInativoCusto.Checked then
      begin
        Conexao.AtribuirParametro('status', 'I');
      end
      else
      begin
        Conexao.AtribuirParametro('status', 'A');
      end;
    end;

    dadosOrdemConsultados := TOrdemServicocodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'ordemServicoCusto/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TCusto);
    end
    else
    begin
      TCusto.Close;
      TCusto.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMOrdemServico.consultarDadosFuncionario(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TOrdemServicocodigo.Value > 0) or (TOrdemServico.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (codigo > 0) then
    begin
      Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
    end;

    if (Assigned(FOrdemServico)) then
    begin
      if FOrdemServico.CBInativoFuncionario.Checked then
      begin
        Conexao.AtribuirParametro('status', 'I');
      end
      else
      begin
        Conexao.AtribuirParametro('status', 'A');
      end;
    end;

    dadosOrdemConsultados := TOrdemServicocodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'ordemServicoFuncionario/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TFuncionario);
    end
    else
    begin
      TFuncionario.Close;
      TFuncionario.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMOrdemServico.consultarDadosItem(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TOrdemServicocodigo.Value > 0) or (TOrdemServico.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (codigo > 0) then
    begin
      Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
    end;

    if (Assigned(FOrdemServico)) then
    begin
      if FOrdemServico.CBMostrarInativoItem.Checked then
      begin
        Conexao.AtribuirParametro('status', 'I');
      end
      else
      begin
        Conexao.AtribuirParametro('status', 'A');
      end;
    end;

    dadosOrdemConsultados := TOrdemServicocodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'ordemServicoItem/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TItem);
    end
    else
    begin
      TItem.Close;
      TItem.Open;
    end;

    Conexao.Destroy;
  end;
end;

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
  jsonArrayTipoFrete, jsonArrayFinalidade, jsonArrayUnidade: TJSONArray;
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

  jsonArrayUnidade := TJSONArray.Create;

  json := TJSONObject.Create;
  json.AddPair('descricao', 'GR');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'M');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'M3');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'M2');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'T');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'UN');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'PC');

  jsonArrayUnidade.Add(json);

  json := TJSONObject.Create;
  json.AddPair('descricao', 'KG');

  jsonArrayUnidade.Add(json);

  converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArrayUnidade), QUnidade);
  QUnidade.Active;
end;

procedure TFDMOrdemServico.GetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

function TFDMOrdemServico.excluirOrdem: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'ordemServicoExcluir/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.TOrdemServicoAfterScroll(DataSet: TDataSet);
begin
  if (Assigned(FOrdemServico)) and
     (FOrdemServico.PCTela.ActivePage = FOrdemServico.TBCadastro) and
     (TOrdemServico.RecordCount > 0) then
  begin
    consultarDadosItem(0, False);
    consultarDadosProduto(0, False);
    consultarDadosCusto(0, False);
    consultarDadosFuncionario(0, False);

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
