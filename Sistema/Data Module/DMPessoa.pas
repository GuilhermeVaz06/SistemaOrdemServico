unit DMPessoa;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils;

type
  TFDMPessoa = class(TDataModule)
    DPessoa: TDataSource;
    TPessoa: TFDMemTable;
    TPessoacodigo: TIntegerField;
    TPessoacadastradoPor: TStringField;
    TPessoaalteradoPor: TStringField;
    TPessoadataCadastro: TStringField;
    TPessoadataAlteracao: TStringField;
    TPessoastatus: TStringField;
    TPessoacodigoTipoDocumento: TIntegerField;
    TPessoatipoDocumento: TStringField;
    TPessoaqtdeCaracteres: TIntegerField;
    TPessoamascaraCaracteres: TStringField;
    TPessoadocumento: TStringField;
    TPessoarazaoSocial: TStringField;
    TPessoanomeFantasia: TStringField;
    TPessoatelefone: TStringField;
    TPessoaemail: TStringField;
    TPessoaobservacao: TMemoField;
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
    TPessoasenha: TStringField;
    TPessoanome: TStringField;
    TPessoacodigoFuncao: TIntegerField;
    TPessoafuncao: TStringField;
    procedure MemoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TPessoadocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure telefoneGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TPessoaAfterScroll(DataSet: TDataSet);
    procedure TOutroDocumentodocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TEnderecocepGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TContatodocumentoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    tipoCadastro: string;
    dadosPessoaConsultados: Integer;
    procedure consultarDados(codigo: integer);
    function cadastrarPessoa: Boolean;
    function alterarPessoa: Boolean;
    function inativarPessoa: Boolean;
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
  FDMPessoa: TFDMPessoa;

implementation

uses UFuncao, UConexao, Pessoa;

{$R *.dfm}

function TFDMPessoa.alterarContato: Boolean;
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

function TFDMPessoa.alterarEndereco: Boolean;
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

function TFDMPessoa.alterarOutroDocumento: Boolean;
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

function TFDMPessoa.cadastrarPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := tipoCadastro;
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TPessoacodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TPessoadocumento.Value);

  if (tipoCadastro <> 'usuario') and (tipoCadastro <> 'funcionario') then
  begin
    Conexao.AtribuirBody('razaoSocial', TPessoarazaoSocial.Value);
    Conexao.AtribuirBody('nomeFantasia', TPessoanomeFantasia.Value);
  end
  else if (tipoCadastro = 'usuario') or (tipoCadastro = 'funcionario') then
  begin
    if (FDMPessoa.tipoCadastro = 'usuario') then
    begin
      Conexao.AtribuirBody('senha', TPessoasenha.Value);
    end
    else if (FDMPessoa.tipoCadastro = 'funcionario') then
    begin
      Conexao.AtribuirBody('codigoFuncao', IntToStrSenaoZero(TPessoacodigoFuncao.Value));
    end;

    Conexao.AtribuirBody('nome', TPessoanome.Value);
  end;

  Conexao.AtribuirBody('telefone', TPessoatelefone.Value);
  Conexao.AtribuirBody('email', TPessoaemail.Value);
  Conexao.AtribuirBody('observacao', TPessoaobservacao.Value);
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
      TPessoacodigo.Value := json.GetValue<Integer>('codigo', 0);
      TPessoacadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TPessoaalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TPessoadataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TPessoadataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TPessoastatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMPessoa.cadastrarContato: Boolean;
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

function TFDMPessoa.cadastrarEndereco: Boolean;
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

function TFDMPessoa.cadastrarOutroDocumento: Boolean;
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

function TFDMPessoa.alterarPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := tipoCadastro + '/' + IntToStrSenaoZero(TPessoacodigo.Value);
  Conexao.AtribuirBody('codigoTipoDocumento', IntToStrSenaoZero(TPessoacodigoTipoDocumento.Value));
  Conexao.AtribuirBody('documento', TPessoadocumento.Value);

  if (tipoCadastro <> 'usuario') and (tipoCadastro <> 'funcionario')  then
  begin
    Conexao.AtribuirBody('razaoSocial', TPessoarazaoSocial.Value);
    Conexao.AtribuirBody('nomeFantasia', TPessoanomeFantasia.Value);
  end
  else if (tipoCadastro = 'usuario') or (tipoCadastro = 'funcionario')  then
  begin
    if (tipoCadastro = 'usuario') then
    begin
      Conexao.AtribuirBody('senha', TPessoasenha.Value);
    end
    else if (FDMPessoa.tipoCadastro = 'funcionario') then
    begin
      Conexao.AtribuirBody('codigoFuncao', IntToStrSenaoZero(TPessoacodigoFuncao.Value));
    end;

    Conexao.AtribuirBody('nome', TPessoanome.Value);
  end;

  Conexao.AtribuirBody('telefone', TPessoatelefone.Value);
  Conexao.AtribuirBody('email', TPessoaemail.Value);
  Conexao.AtribuirBody('observacao', TPessoaobservacao.Value);
  Conexao.AtribuirBody('status', TPessoastatus.Value);
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
      TPessoacodigo.Value := json.GetValue<Integer>('codigo', 0);
      TPessoacadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TPessoaalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TPessoadataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TPessoadataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TPessoastatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMPessoa.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FPessoa)) then
  begin
    if (tipoCadastro <> 'usuario') and (tipoCadastro <> 'funcionario')  then
    begin
      if (FPessoa.ERazaoSocial.Text <> '') then
      begin
        Conexao.AtribuirParametro('razaoSocial', FPessoa.ERazaoSocial.Text);
      end;

      if (FPessoa.ENomeFantasia.Text <> '') then
      begin
        Conexao.AtribuirParametro('nomeFantasia', FPessoa.ENomeFantasia.Text);
      end;
    end
    else
    begin
      if (FPessoa.ERazaoSocial.Text <> '') then
      begin
        Conexao.AtribuirParametro('nome', FPessoa.ERazaoSocial.Text);
      end;
    end;

    if FPessoa.CBMostrarInativo.Checked then
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TPessoa);
  end
  else
  begin
    TPessoa.Close;
    TPessoa.Open;
  end;

  Conexao.Destroy;
end;

procedure TFDMPessoa.consultarDadosContato(codigo: integer;
  mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TPessoacodigo.Value > 0) or (TPessoa.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FPessoa)) then
    begin
      if FPessoa.CBInativoContato.Checked then
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

    dadosPessoaConsultados := TPessoacodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'contato/' + IntToStrSenaoZero(TPessoacodigo.Value);
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

procedure TFDMPessoa.consultarDadosEndereco(codigo: integer;
  mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TPessoacodigo.Value > 0) or (TPessoa.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FPessoa)) then
    begin
      if FPessoa.CBInativoEndereco.Checked then
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

    dadosPessoaConsultados := TPessoacodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'endereco/' + IntToStrSenaoZero(TPessoacodigo.Value);
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

procedure TFDMPessoa.consultarDadosOutroDocumento(codigo: integer; mostrarErro: Boolean);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  if (TPessoacodigo.Value > 0) or (TPessoa.State = dsInsert) then
  begin
    Conexao := TConexao.Create;

    if (Assigned(FPessoa)) then
    begin
      if FPessoa.CBInativoOutroDocumento.Checked then
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

    dadosPessoaConsultados := TPessoacodigo.Value;

    Conexao.metodo := rmGET;
    Conexao.url := 'outroDocumento/' + IntToStrSenaoZero(TPessoacodigo.Value);
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

function TFDMPessoa.inativarPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := tipoCadastro + '/' + IntToStrSenaoZero(TPessoacodigo.Value);
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

function TFDMPessoa.inativarContato: Boolean;
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

function TFDMPessoa.inativarEndereco: Boolean;
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

function TFDMPessoa.inativarOutroDocumento: Boolean;
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

procedure TFDMPessoa.MemoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

procedure TFDMPessoa.TPessoaAfterScroll(
  DataSet: TDataSet);
begin
  if (Assigned(FPessoa)) then
  begin
    if (FPessoa.PCTela.ActivePage = FPessoa.TBCadastro) then
    begin
      consultarDadosOutroDocumento(0, False);
      consultarDadosEndereco(0, False);
      consultarDadosContato(0, False);
    end;
  end;
end;

procedure TFDMPessoa.TPessoadocumentoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatMaskText(TPessoamascaraCaracteres.Value, TPessoadocumento.Value);
end;

procedure TFDMPessoa.TContatodocumentoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText(TContatomascaraCararteres.Value, TContatodocumento.Value);
end;

procedure TFDMPessoa.telefoneGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := mascaraTelefone((Sender as TStringField).Value);
end;

procedure TFDMPessoa.TEnderecocepGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText('99999-999;0', TEnderecocep.Value);
end;

procedure TFDMPessoa.TOutroDocumentodocumentoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := FormatMaskText(TOutroDocumentomascaraCaracteres.Value, TOutroDocumentodocumento.Value);
end;

procedure TFDMPessoa.consultarTipoDocumento;
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

procedure TFDMPessoa.DataModuleCreate(Sender: TObject);
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

function TFDMPessoa.excluirPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := tipoCadastro + 'Excluir/' + IntToStrSenaoZero(TPessoacodigo.Value);
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
