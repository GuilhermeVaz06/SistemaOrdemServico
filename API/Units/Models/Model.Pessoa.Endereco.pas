unit Model.Pessoa.Endereco;

interface

uses Model.Sessao, Model.Pessoa, Model.Cidade, Model.TipoEndereco, System.SysUtils,
     ZDataset, System.Classes;

type TEndereco = class

  private
    FCodigo: integer;
    FPessoa: TPessoa;
    FTipoEndereco: TTipoEndereco;
    FCep: string;
    FLongradouro: string;
    FNumero: string;
    FBairro: string;
    FComplemento: string;
    FObservacao: string;
    FCidade: TCidade;
    FPrioridade: string;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

    function contar: integer;
    function consultarCodigo(codigo: integer): TEndereco;
    function montarEndereco(query: TZQuery): TEndereco;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property pessoa: TPessoa read FPessoa write FPessoa;
    property tipoEndereco: TTipoEndereco read FTipoEndereco write FTipoEndereco;
    property cep: string read FCep write FCep;
    property longradouro: string read FLongradouro write FLongradouro;
    property numero: string read FNumero write FNumero;
    property bairro: string read FBairro write FBairro;
    property complemento: string read FComplemento write FComplemento;
    property observacao: string read FObservacao write FObservacao;
    property cidade: TCidade read FCidade write FCidade;
    property prioridade: string read FPrioridade write FPrioridade;
    property cadastradoPor: TSessao read FCadastradoPor write FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor write FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao write FUltimaAlteracao;
    property status: string read FStatus write FStatus;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;

    procedure limpar;
    procedure atualizarLog(codigo, status: Integer; resposta: string);

    function consultar: TArray<TEndereco>;
    function consultarChave: TEndereco;
    function existeRegistro: TEndereco;
    function cadastrarEndereco: TEndereco;
    function alterarEndereco: TEndereco;
    function inativarEndereco: TEndereco;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TEndereco }

function TEndereco.alterarEndereco: TEndereco;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_endereco`');
  sql.Add('   SET CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FTipoEndereco.id));
  sql.Add('     , CEP = ' + QuotedStr(FCep));
  sql.Add('     , LONGRADOURO = ' + QuotedStr(FLongradouro));
  sql.Add('     , NUMERO = ' + QuotedStr(FNumero));
  sql.Add('     , BAIRRO = ' + QuotedStr(FBairro));
  sql.Add('     , COMPLEMENTO = ' + QuotedStr(FComplemento));
  sql.Add('     , OBSERVACAO = ' + QuotedStr(FObservacao));
  sql.Add('     , CODIGO_CIDADE = ' + IntToStrSenaoZero(FCidade.id));
  sql.Add('     , PRIORIDADE = ' + QuotedStr(FPrioridade));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TEndereco.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TEndereco.cadastrarEndereco: TEndereco;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('pessoa_endereco', 'CODIGO_ENDERECO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `pessoa_endereco` (`CODIGO_PESSOA`, `CODIGO_ENDERECO`, `CODIGO_TIPO_ENDERECO`');
  sql.Add(', `CEP`, `LONGRADOURO`, `NUMERO`, `BAIRRO`, `COMPLEMENTO`, `OBSERVACAO`, `CODIGO_CIDADE`');
  sql.Add(', `PRIORIDADE`, `CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FPessoa.id));                                 //CODIGO_PESSOA
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_OUTRO_DOCUMENTO
  sql.Add(',' + IntToStrSenaoZero(FTipoEndereco.id));                           //CODIGO_TIPO_ENDERECO
  sql.Add(',' + QuotedStr(FCep));                                               //CEP
  sql.Add(',' + QuotedStr(FLongradouro));                                       //LONGRADOURO
  sql.Add(',' + QuotedStr(FNumero));                                            //NUMERO
  sql.Add(',' + QuotedStr(FBairro));                                            //BAIRRO
  sql.Add(',' + QuotedStr(FComplemento));                                       //COMPLEMENTO
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + IntToStrSenaoZero(FCidade.id));                                 //CODIGO_CIDADE
  sql.Add(',' + QuotedStr(FPrioridade));                                        //PRIORIDADE
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TEndereco.consultar: TArray<TEndereco>;
var
  query: TZQuery;
  enderecos: TArray<TEndereco>;
  contador: Integer;
  sql: TStringList;
  restante: Integer;
begin
  try
    if (FLimite = 0) or(FLimite > 500) then
    begin
      FLimite := 500;
    end;

    restante := contar() - FLimite - FOffset;

    if (restante > 0) then
    begin
      FMaisRegistro := True;
    end
    else
    begin
      FMaisRegistro := False;
    end;

    sql := TStringList.Create;
    sql.Add('SELECT pessoa_endereco.CODIGO_PESSOA, pessoa_endereco.CODIGO_ENDERECO, pessoa_endereco.CODIGO_TIPO_ENDERECO');
    sql.Add(', pessoa_endereco.CEP, pessoa_endereco.LONGRADOURO, pessoa_endereco.NUMERO, pessoa_endereco.BAIRRO');
    sql.Add(', pessoa_endereco.COMPLEMENTO, pessoa_endereco.OBSERVACAO, pessoa_endereco.CODIGO_CIDADE, pessoa_endereco.PRIORIDADE');
    sql.Add(', pessoa_endereco.CODIGO_SESSAO_CADASTRO, pessoa_endereco.CODIGO_SESSAO_ALTERACAO, pessoa_endereco.DATA_CADASTRO');
    sql.Add(', pessoa_endereco.DATA_ULTIMA_ALTERACAO, pessoa_endereco.`STATUS`, pessoa.NOME_FANTASIA nomePessoa');
    sql.Add(', tipo_endereco.DESCRICAO tipoEndereco, cidade.NOME nomeCidade');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_endereco.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_endereco.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM pessoa_endereco, pessoa, tipo_endereco, cidade');
    sql.Add(' WHERE pessoa_endereco.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');
    sql.Add('   AND pessoa_endereco.CODIGO_TIPO_ENDERECO = tipo_endereco.CODIGO_TIPO_ENDERECO');
    sql.Add('   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');

    if (FPessoa.id > 0) then
    begin
      sql.Add('   AND pessoa_endereco.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND pessoa_endereco.CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
    end;

    sql.Add('   AND pessoa_endereco.`STATUS` = ' + QuotedStr(FStatus));
    sql.Add(' LIMIT ' + IntToStrSenaoZero(FOffset) + ', ' + IntToStrSenaoZero(FLimite));

    query := FConexao.executarComandoDQL(sql.Text);

    if not Assigned(query)
    or (query = nil)
    or (query.RecordCount = 0) then
    begin
      Result := [];
    end
    else
    begin
      query.First;
      FRegistrosAfetados := FConexao.registrosAfetados;
      SetLength(enderecos, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        enderecos[contador] := montarEndereco(query);
        query.Next;
        inc(contador);
      end;

      Result := enderecos;
    end;

    FreeAndNil(sql);
  except
    on E: Exception do
    begin
      raise Exception.Create(e.Message);
      Result := nil;
      FreeAndNil(sql);
    end;
  end;
end;

function TEndereco.consultarChave: TEndereco;
var
  query: TZQuery;
  enderecoConsultado: TEndereco;
  sql: TStringList;
begin
  enderecoConsultado := TEndereco.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ENDERECO, LONGRADOURO');
  sql.Add('  FROM pessoa_endereco');
  sql.Add(' WHERE CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    enderecoConsultado.Destroy;
    enderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    enderecoConsultado.FCodigo := query.FieldByName('CODIGO_OUTRO_DOCUMENTO').Value;
    enderecoConsultado.FLongradouro := query.FieldByName('DOCUMENTO').Value;
  end;

  Result := enderecoConsultado;

  FreeAndNil(sql);
end;

function TEndereco.consultarCodigo(codigo: integer): TEndereco;
var
  query: TZQuery;
  sql: TStringList;
  enderecoConsultado: TEndereco;
begin
  sql := TStringList.Create;
  sql.Add('SELECT pessoa_endereco.CODIGO_PESSOA, pessoa_endereco.CODIGO_ENDERECO, pessoa_endereco.CODIGO_TIPO_ENDERECO');
  sql.Add(', pessoa_endereco.CEP, pessoa_endereco.LONGRADOURO, pessoa_endereco.NUMERO, pessoa_endereco.BAIRRO');
  sql.Add(', pessoa_endereco.COMPLEMENTO, pessoa_endereco.OBSERVACAO, pessoa_endereco.CODIGO_CIDADE, pessoa_endereco.PRIORIDADE');
  sql.Add(', pessoa_endereco.CODIGO_SESSAO_CADASTRO, pessoa_endereco.CODIGO_SESSAO_ALTERACAO, pessoa_endereco.DATA_CADASTRO');
  sql.Add(', pessoa_endereco.DATA_ULTIMA_ALTERACAO, pessoa_endereco.`STATUS`, pessoa.NOME_FANTASIA nomePessoa');
  sql.Add(', tipo_endereco.DESCRICAO tipoEndereco, cidade.NOME nomeCidade');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_endereco.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_endereco.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM pessoa_endereco, pessoa, tipo_endereco, cidade');
  sql.Add(' WHERE pessoa_endereco.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');
  sql.Add('   AND pessoa_endereco.CODIGO_TIPO_ENDERECO = tipo_endereco.CODIGO_TIPO_ENDERECO');
  sql.Add('   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');
  sql.Add('   AND pessoa_endereco.CODIGO_ENDERECO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    enderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    enderecoConsultado := montarEndereco(query);
  end;

  Result := enderecoConsultado;
  FreeAndNil(sql);
end;

function TEndereco.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(pessoa_endereco.CODIGO_ENDERECO) TOTAL');
  sql.Add('  FROM pessoa_endereco, pessoa, tipo_endereco, cidade');
  sql.Add(' WHERE pessoa_endereco.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');
  sql.Add('   AND pessoa_endereco.CODIGO_TIPO_ENDERECO = tipo_endereco.CODIGO_TIPO_ENDERECO');
  sql.Add('   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');

  if (FPessoa.id > 0) then
  begin
    sql.Add('   AND pessoa_endereco.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND pessoa_endereco.CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add('   AND pessoa_endereco.`STATUS` = ' + QuotedStr(FStatus));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    Result := 0;
  end
  else
  begin
    Result := query.FieldByName('TOTAL').Value;
  end;

  FreeAndNil(sql);
end;

constructor TEndereco.Create;
begin
  FPessoa := TPessoa.Create;
  FTipoEndereco := TTipoEndereco.Create;
  FCidade := TCidade.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TEndereco.Destroy;
begin
  if Assigned(FPessoa) then
  begin
    FPessoa.Destroy;
  end;

  if Assigned(FTipoEndereco) then
  begin
    FTipoEndereco.Destroy;
  end;

  if Assigned(FCidade) then
  begin
    FCidade.Destroy;
  end;

  if Assigned(FCadastradoPor) then
  begin
    FCadastradoPor.Destroy;
  end;

  if Assigned(FAlteradoPor) then
  begin
    FAlteradoPor.Destroy;
  end;

  inherited;
end;

function TEndereco.existeRegistro: TEndereco;
var
  query: TZQuery;
  enderecoConsultado: TEndereco;
  sql: TStringList;
begin
  enderecoConsultado := TEndereco.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ENDERECO, CEP, `STATUS`');
  sql.Add('  FROM pessoa_endereco');
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  sql.Add('   AND CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FTipoEndereco.id));
  sql.Add('   AND CEP = ' + QuotedStr(FCep));
  sql.Add('   AND NUMERO = ' + QuotedStr(FNumero));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_OUTRO_DOCUMENTO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    enderecoConsultado.Destroy;
    enderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    enderecoConsultado.FCodigo := query.FieldByName('CODIGO_ENDERECO').Value;
    enderecoConsultado.FCep := query.FieldByName('CEP').Value;
    enderecoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := enderecoConsultado;

  FreeAndNil(sql);
end;

function TEndereco.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TEndereco.inativarEndereco: TEndereco;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_endereco`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TEndereco.limpar;
begin
  FCodigo := 0;
  FPessoa.limpar;
  FTipoEndereco.limpar;
  FCep := '';
  FLongradouro := '';
  FNumero := '';
  FBairro := '';
  FComplemento := '';
  FObservacao := '';
  FCidade.limpar;
  FPrioridade := '';
  FCadastradoPor.limpar;
  FAlteradoPor.limpar;
  FDataCadastro := Now;
  FUltimaAlteracao := Now;
  FStatus := '';
  FLimite := 0;
  FOffset := 0;
  FRegistrosAfetados := 0;
  FMaisRegistro := False;
end;

function TEndereco.montarEndereco(query: TZQuery): TEndereco;
var
  data: TEndereco;
begin
  try
    data := TEndereco.Create;

    data.FCodigo := query.FieldByName('CODIGO_ENDERECO').Value;
    data.FPessoa.id := query.FieldByName('CODIGO_PESSOA').Value;
    data.FPessoa.nomeFantasia := query.FieldByName('nomePessoa').Value;
    FTipoEndereco.id := query.FieldByName('CODIGO_TIPO_ENDERECO').Value;
    FTipoEndereco.descricao := query.FieldByName('tipoEndereco').Value;
    FCep := query.FieldByName('CEP').Value;
    FLongradouro := query.FieldByName('LONGRADOURO').Value;
    FNumero := query.FieldByName('NUMERO').Value;
    FBairro := query.FieldByName('BAIRRO').Value;
    FComplemento := query.FieldByName('COMPLEMENTO').Value;
    FObservacao := query.FieldByName('OBSERVACAO').AsString;
    FCidade.id := query.FieldByName('CODIGO_CIDADE').Value;
    FCidade.nome := query.FieldByName('nomeCidade').Value;
    FPrioridade := query.FieldByName('PRIORIDADE').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Endereço ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TEndereco.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
