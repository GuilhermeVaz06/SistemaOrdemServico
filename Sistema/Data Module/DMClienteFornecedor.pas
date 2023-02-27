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
    TOutroDocumentoobservacao: TMemoField;
    TOutroDocumentocadastradoPor: TStringField;
    TOutroDocumentoalteradoPor: TStringField;
    TOutroDocumentodataCadastro: TStringField;
    TOutroDocumentodataAlteracao: TStringField;
    TOutroDocumentostatus: TStringField;
    TOutroDocumentocodigo: TIntegerField;
    TOutroDocumentomascaraCaracteres: TStringField;
    DEndereco: TDataSource;
    TEndereco: TFDMemTable;
    TEnderecocodigo: TIntegerField;
    TEnderecocodigoPessoa: TIntegerField;
    TEnderecocodigoTipoEndereco: TIntegerField;
    TEnderecotipoEndereco: TStringField;
    TEnderecocep: TStringField;
    TEnderecolongradouro: TStringField;
    TEndereconumero: TStringField;
    TEnderecobairro: TStringField;
    TEnderecocomplemento: TStringField;
    TEnderecoobservacao: TMemoField;
    TEnderecocodigoCidade: TIntegerField;
    TEndereconomeCidade: TStringField;
    TEnderecoprioridade: TStringField;
    TEnderecocadastradoPor: TStringField;
    TEnderecoalteradoPor: TStringField;
    TEnderecodataCadastro: TStringField;
    TEnderecodataAlteracao: TStringField;
    TEnderecostatus: TStringField;
    TEndereconomeEstado: TStringField;
    TEndereconomePais: TStringField;
    DPrioridade: TDataSource;
    QPrioridade: TFDMemTable;
    QPrioridadecodigo: TStringField;
    QPrioridadedescricao: TStringField;
    TOutroDocumentodataEmissao: TStringField;
    TOutroDocumentodataVencimento: TStringField;
    DContato: TDataSource;
    TContato: TFDMemTable;
    TContatocodigo: TIntegerField;
    TContatocodigoPessoa: TIntegerField;
    TContatocodigoTipoDocumento: TIntegerField;
    TContatotipoDocumento: TStringField;
    TContatomascaraCararteres: TStringField;
    TContatodocumento: TStringField;
    TContatonome: TStringField;
    TContatodataNascimento: TStringField;
    TContatofuncao: TStringField;
    TContatotelefone: TStringField;
    TContatoemail: TStringField;
    TContatocadastradoPor: TStringField;
    TContatoalteradoPor: TStringField;
    TContatodataCadastro: TStringField;
    TContatodataAlteracao: TStringField;
    TContatostatus: TStringField;
    TContatoobservacao: TMemoField;
    TClienteFornecedorsenha: TStringField;
    TClienteFornecedornome: TStringField;
    procedure MemoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClienteFornecedordocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure telefoneGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TClienteFornecedorAfterScroll(DataSet: TDataSet);
    procedure TOutroDocumentodocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure TEnderecocepGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TContatodocumentoGetText(Sender: TField; var Text: string;
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
    procedure consultarDadosEndereco(codigo: integer; mostrarErro: Boolean);
    function cadastrarEndereco: Boolean;
    function alterarEndereco: Boolean;
    function inativarEndereco: Boolean;
    procedure consultarDadosContato(codigo: integer; mostrarErro: Boolean);
    function cadastrarContato: Boolean;
    function alterarContato: Boolean;
    function inativarContato: Boolean;
    function excluirPessoa: Boolean;
  end;

var
  FDMClienteFornecedor: TFDMClienteFornecedor;

implementation

uses UFuncao, UConexao, ClienteFornecedor;

{$R *.dfm}

function TFDMClienteFornecedor.alterarContato: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'contato/' + IntToStrSenaoZero(TContatocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TContatocodigo.Value);
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TContatocodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TContatodocumento.Value);
  Conexao.AtribuirBody('nome',  TContatonome.Value);
  Conexao.AtribuirBody('dataNascimento', TContatodataNascimento.Value);
  Conexao.AtribuirBody('funcao',  TContatofuncao.Value);
  Conexao.AtribuirBody('telefone',  TContatotelefone.Value);
  Conexao.AtribuirBody('email',  TContatoemail.Value);
  Conexao.AtribuirBody('observacao', TContatoobservacao.Value);
  Conexao.AtribuirBody('status', TContatostatus.Value);
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
      TContatocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TContatotipoDocumento.Value := json.GetValue<string>('tipoDocumento', '');
      TContatomascaraCararteres.Value := json.GetValue<string>('mascaraCararteres', '');
      TContatocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TContatoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TContatodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TContatodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TContatostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMClienteFornecedor.alterarEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'endereco/' + IntToStrSenaoZero(TEnderecocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TEnderecocodigo.Value);
  Conexao.AtribuirBody('codigoTipoEndereco', IntToStrSenaoZero(TEnderecocodigoTipoEndereco.Value));
  Conexao.AtribuirBody('cep', TEnderecocep.Value);
  Conexao.AtribuirBody('longradouro',  TEnderecolongradouro.Value);
  Conexao.AtribuirBody('numero',  TEndereconumero.Value);
  Conexao.AtribuirBody('bairro',  TEnderecobairro.Value);
  Conexao.AtribuirBody('complemento',  TEnderecocomplemento.Value);
  Conexao.AtribuirBody('observacao',  TEnderecoobservacao.Value);
  Conexao.AtribuirBody('codigoCidade', IntToStrSenaoZero( TEnderecocodigoCidade.Value));
  Conexao.AtribuirBody('prioridade',  TEnderecoprioridade.Value);
  Conexao.AtribuirBody('status', TEnderecostatus.Value);
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
      TEnderecocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TEnderecotipoEndereco.Value := json.GetValue<string>('tipoEndereco', '');
      TEndereconomeCidade.Value := json.GetValue<string>('nomeCidade', '');
      TEndereconomeEstado.Value := json.GetValue<string>('nomeEstado', '');
      TEndereconomePais.Value := json.GetValue<string>('nomePais', '');
      TEnderecocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TEnderecoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TEnderecodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TEnderecodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TEnderecostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

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
  Conexao.AtribuirBody('dataEmissao', TOutroDocumentodataEmissao.Value);
  Conexao.AtribuirBody('dataVencimento', TOutroDocumentodataVencimento.Value);
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

  if (tipoCadastro <> 'usuario') then
  begin
    Conexao.AtribuirBody('razaoSocial', TClienteFornecedorrazaoSocial.Value);
    Conexao.AtribuirBody('nomeFantasia', TClienteFornecedornomeFantasia.Value);
  end
  else
  begin
    Conexao.AtribuirBody('nome', TClienteFornecedornome.Value);
    Conexao.AtribuirBody('senha', TClienteFornecedorsenha.Value);
  end;

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

function TFDMClienteFornecedor.cadastrarContato: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'contato';
  Conexao.AtribuirBody('codigoPessoa', IntToStrSenaoZero(TContatocodigoPessoa.Value));
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TContatocodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TContatodocumento.Value);
  Conexao.AtribuirBody('nome',  TContatonome.Value);
  Conexao.AtribuirBody('dataNascimento', TContatodataNascimento.Value);
  Conexao.AtribuirBody('funcao',  TContatofuncao.Value);
  Conexao.AtribuirBody('telefone',  TContatotelefone.Value);
  Conexao.AtribuirBody('email',  TContatoemail.Value);
  Conexao.AtribuirBody('observacao', TContatoobservacao.Value);
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
      TContatocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TContatotipoDocumento.Value := json.GetValue<string>('tipoDocumento', '');
      TContatomascaraCararteres.Value := json.GetValue<string>('mascaraCararteres', '');
      TContatocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TContatoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TContatodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TContatodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TContatostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMClienteFornecedor.cadastrarEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'endereco';
  Conexao.AtribuirBody('codigoPessoa', IntToStrSenaoZero(TEnderecocodigoPessoa.Value));
  Conexao.AtribuirBody('codigoTipoEndereco', IntToStrSenaoZero(TEnderecocodigoTipoEndereco.Value));
  Conexao.AtribuirBody('cep', TEnderecocep.Value);
  Conexao.AtribuirBody('longradouro',  TEnderecolongradouro.Value);
  Conexao.AtribuirBody('numero',  TEndereconumero.Value);
  Conexao.AtribuirBody('bairro',  TEnderecobairro.Value);
  Conexao.AtribuirBody('complemento',  TEnderecocomplemento.Value);
  Conexao.AtribuirBody('observacao',  TEnderecoobservacao.Value);
  Conexao.AtribuirBody('codigoCidade', IntToStrSenaoZero( TEnderecocodigoCidade.Value));
  Conexao.AtribuirBody('prioridade',  TEnderecoprioridade.Value);
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
      TEnderecocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TEnderecotipoEndereco.Value := json.GetValue<string>('tipoEndereco', '');
      TEndereconomeCidade.Value := json.GetValue<string>('nomeCidade', '');
      TEndereconomeEstado.Value := json.GetValue<string>('nomeEstado', '');
      TEndereconomePais.Value := json.GetValue<string>('nomePais', '');
      TEnderecocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TEnderecoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TEnderecodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TEnderecodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TEnderecostatus.Value := json.GetValue<string>('status', 'A');

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
  Conexao.AtribuirBody('dataEmissao', TOutroDocumentodataEmissao.Value);
  Conexao.AtribuirBody('dataVencimento', TOutroDocumentodataVencimento.Value);
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

  if (tipoCadastro <> 'usuario') then
  begin
    Conexao.AtribuirBody('razaoSocial', TClienteFornecedorrazaoSocial.Value);
    Conexao.AtribuirBody('nomeFantasia', TClienteFornecedornomeFantasia.Value);
  end
  else
  begin
    Conexao.AtribuirBody('nome', TClienteFornecedornome.Value);
    Conexao.AtribuirBody('senha', TClienteFornecedorsenha.Value);
  end;

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
    if (FClienteFornecedor.ERazaoSocial.Text <> '') and (tipoCadastro <> 'usuario') then
    begin
      Conexao.AtribuirParametro('razaoSocial', FClienteFornecedor.ERazaoSocial.Text);
    end;

    if (FClienteFornecedor.ENomeFantasia.Text <> '') and (tipoCadastro <> 'usuario') then
    begin
      Conexao.AtribuirParametro('nomeFantasia', FClienteFornecedor.ENomeFantasia.Text);
    end;

    if (FClienteFornecedor.ERazaoSocial.Text <> '') and (tipoCadastro = 'usuario') then
    begin
      Conexao.AtribuirParametro('nome', FClienteFornecedor.ERazaoSocial.Text);
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

procedure TFDMClienteFornecedor.consultarDadosContato(codigo: integer;
  mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TClienteFornecedorcodigo.Value > 0) or (TClienteFornecedor.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FClienteFornecedor)) then
    begin
      if FClienteFornecedor.CBInativoContato.Checked then
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
    Conexao.url := 'contato/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TContato);
    end
    else
    begin
      TContato.Close;
      TContato.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMClienteFornecedor.consultarDadosEndereco(codigo: integer;
  mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TClienteFornecedorcodigo.Value > 0) or (TClienteFornecedor.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FClienteFornecedor)) then
    begin
      if FClienteFornecedor.CBInativoEndereco.Checked then
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
    Conexao.url := 'endereco/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
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
      converterArrayJsonQuery(converterJsonArrayRestResponse(master), TEndereco);
    end
    else
    begin
      TEndereco.Close;
      TEndereco.Open;
    end;

    Conexao.Destroy;
  end;
end;

procedure TFDMClienteFornecedor.consultarDadosOutroDocumento(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TClienteFornecedorcodigo.Value > 0) or (TClienteFornecedor.State = dsInsert) then
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

function TFDMClienteFornecedor.inativarContato: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'contato/' + IntToStrSenaoZero(TContatocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TContatocodigo.Value);
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

function TFDMClienteFornecedor.inativarEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'endereco/' + IntToStrSenaoZero(TEnderecocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TEnderecocodigo.Value);
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
  Conexao.url := 'outroDocumento/' + IntToStrSenaoZero(TOutroDocumentocodigoPessoa.Value) +
                 '/' + IntToStrSenaoZero(TOutroDocumentocodigo.Value);
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
  if (Assigned(FClienteFornecedor)) then
  begin
    if (FClienteFornecedor.PCTela.ActivePage = FClienteFornecedor.TBCadastro) then
    begin
      consultarDadosOutroDocumento(0, False);
      consultarDadosEndereco(0, False);
      consultarDadosContato(0, False);
    end;
  end;
end;

procedure TFDMClienteFornecedor.TClienteFornecedordocumentoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatMaskText(TClienteFornecedormascaraCaracteres.Value, TClienteFornecedordocumento.Value);
end;

procedure TFDMClienteFornecedor.TContatodocumentoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText(TContatomascaraCararteres.Value, TContatodocumento.Value);
end;

procedure TFDMClienteFornecedor.telefoneGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := mascaraTelefone((Sender as TStringField).Value);
end;

procedure TFDMClienteFornecedor.TEnderecocepGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText('99999-999;0', TEnderecocep.Value);
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

procedure TFDMClienteFornecedor.DataModuleCreate(Sender: TObject);
var
  jsonArray: TJSONArray;
  json: TJSONObject;
begin
  jsonArray := TJSONArray.Create;

  json := TJSONObject.Create;
  json.AddPair('codigo', 'P');
  json.AddPair('descricao', 'Principal');

  jsonArray.Add(json);

  json := TJSONObject.Create;
  json.AddPair('codigo', 'S');
  json.AddPair('descricao', 'Secundario');

  jsonArray.Add(json);

  converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArray), QPrioridade);
  QPrioridade.Active;
end;

function TFDMClienteFornecedor.excluirPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := tipoCadastro + 'Excluir/' + IntToStrSenaoZero(TClienteFornecedorcodigo.Value);
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

end.
