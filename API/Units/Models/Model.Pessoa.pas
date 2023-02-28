unit Model.Pessoa;

interface

uses Model.Sessao, Model.TipoPessoa, Model.TipoDocumento, System.SysUtils,
     ZDataset, System.Classes;

type TPessoa = class

  private
    FCodigo: integer;
    FTipoCadastro: TTipoPessoa;
    FTipoDocumento: TTipoDocumento;
    FDocumento: string;
    FRazaoSocial: string;
    FNomeFantasia: string;
    FTelefone: string;
    FEmail: string;
    FSenha: string;
    FObservacao: string;
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
    function consultarCodigo(codigo: integer): TPessoa;
    function montarPessoa(query: TZQuery): TPessoa;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property tipoPessoa: TTipoPessoa read FTipoCadastro write FTipoCadastro;
    property tipoDocumento: TTipoDocumento read FTipoDocumento write FTipoDocumento;
    property documento: string read FDocumento write FDocumento;
    property razaoSocial: string read FRazaoSocial write FRazaoSocial;
    property nomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property telefone: string read FTelefone write FTelefone;
    property email: string read FEmail write FEmail;
    property senha: string read FSenha write FSenha;
    property observacao: string read FObservacao write FObservacao;
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

    function consultar: TArray<TPessoa>;
    function excluirCadastro: Boolean;
    function consultarChave: TPessoa;
    function existeRegistro: TPessoa;
    function cadastrarPessoa: TPessoa;
    function alterarPessoa: TPessoa;
    function inativarPessoa: TPessoa;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TPessoa }

function TPessoa.alterarPessoa: TPessoa;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa`');
  sql.Add('   SET CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
  sql.Add('     , DOCUMENTO = ' + QuotedStr(trim(soNumeros(FDocumento))));
  sql.Add('     , RAZAO_SOCIAL = ' + QuotedStr(FRazaoSocial));
  sql.Add('     , NOME_FANTASIA = ' + QuotedStr(FNomeFantasia));
  sql.Add('     , TELEFONE = ' + QuotedStr(trim(soNumeros(FTelefone))));
  sql.Add('     , EMAIL = ' + QuotedStr(FEmail));
  sql.Add('     , SENHA = ' + QuotedStr(FSenha));
  sql.Add('     , OBSERVACAO = ' + QuotedStr(FObservacao));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add('     , STATUS = ' + QuotedStr(FStatus));
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TPessoa.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TPessoa.cadastrarPessoa: TPessoa;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('pessoa', 'CODIGO_PESSOA');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `pessoa` (CODIGO_PESSOA, CODIGO_TIPO_PESSOA, CODIGO_TIPO_DOCUMENTO');
  sql.Add(', DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, TELEFONE, EMAIL, SENHA, OBSERVACAO');
  sql.Add(', CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_PESSOA
  sql.Add(',' + IntToStrSenaoZero(FTipoCadastro.id));                           //CODIGO_TIPO_PESSOA
  sql.Add(',' + IntToStrSenaoZero(FTipoDocumento.id));                          //CODIGO_TIPO_DOCUMENTO
  sql.Add(',' + QuotedStr(trim(soNumeros(FDocumento))));                        //DOCUMENTO
  sql.Add(',' + QuotedStr(FRazaoSocial));                                       //RAZAO_SOCIAL
  sql.Add(',' + QuotedStr(FNomeFantasia));                                      //NOME_FANTASIA
  sql.Add(',' + QuotedStr(trim(soNumeros(FTelefone))));                         //TELEFONE
  sql.Add(',' + QuotedStr(FEmail));                                             //EMAIL
  sql.Add(',' + QuotedStr(FSenha));                                             //SENHA
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TPessoa.consultar: TArray<TPessoa>;
var
  query: TZQuery;
  pessoas: TArray<TPessoa>;
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
    sql.Add('SELECT pessoa.CODIGO_PESSOA, pessoa.CODIGO_TIPO_PESSOA, pessoa.CODIGO_TIPO_DOCUMENTO, pessoa.DOCUMENTO');
    sql.Add(', pessoa.RAZAO_SOCIAL, pessoa.NOME_FANTASIA, pessoa.TELEFONE, pessoa.EMAIL, pessoa.SENHA, pessoa.OBSERVACAO');
    sql.Add(', pessoa.CODIGO_SESSAO_CADASTRO, pessoa.CODIGO_SESSAO_ALTERACAO, pessoa.DATA_CADASTRO, pessoa.DATA_ULTIMA_ALTERACAO');
    sql.Add(', pessoa.`STATUS`, tipo_documento.DESCRICAO, tipo_documento.QTDE_CARACTERES, tipo_documento.MASCARA_CARACTERES');
    sql.Add('');
    sql.Add(', (SELECT p2.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa p2, sessao ');
    sql.Add('    WHERE p2.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT p2.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa p2, sessao ');
    sql.Add('    WHERE p2.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM pessoa, tipo_documento');
    sql.Add(' WHERE pessoa.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');
    sql.Add('   AND pessoa.`STATUS` = ' + QuotedStr(FStatus));

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND pessoa.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
    end;

    if  (FTipoCadastro.id > 0) then
    begin
      sql.Add('   AND pessoa.CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));
    end;

    if  (FTipoDocumento.id > 0) then
    begin
      sql.Add('   AND pessoa.CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
    end;

    if  (FTipoDocumento.descricao <> '') then
    begin
      sql.Add('   AND tipo_documento.DESCRICAO LIKE ' + QuotedStr('%' + FTipoDocumento.descricao + '%'));
    end;

    if  (FDocumento <> '') then
    begin
      sql.Add('   AND pessoa.DOCUMENTO LIKE ' + QuotedStr('%' + FDocumento + '%'));
    end;

    if  (FRazaoSocial <> '') then
    begin
      sql.Add('   AND pessoa.RAZAO_SOCIAL LIKE ' + QuotedStr('%' + FRazaoSocial + '%'));
    end;

    if  (FNomeFantasia <> '') then
    begin
      sql.Add('   AND pessoa.NOME_FANTASIA LIKE ' + QuotedStr('%' + FNomeFantasia + '%'));
    end;

    if  (FTelefone <> '') then
    begin
      sql.Add('   AND pessoa.TELEFONE LIKE ' + QuotedStr('%' + FTelefone + '%'));
    end;

    if  (FEmail <> '') then
    begin
      sql.Add('   AND pessoa.EMAIL LIKE ' + QuotedStr('%' + FEmail + '%'));
    end;

    if  (FObservacao <> '') then
    begin
      sql.Add('   AND pessoa.OBSERVACAO LIKE ' + QuotedStr('%' + FObservacao + '%'));
    end;

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
      SetLength(pessoas, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        pessoas[contador] := montarPessoa(query);
        query.Next;
        inc(contador);
      end;

      Result := pessoas;
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

function TPessoa.consultarChave: TPessoa;
var
  query: TZQuery;
  pessoaConsultado: TPessoa;
  sql: TStringList;
begin
  pessoaConsultado := TPessoa.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PESSOA, NOME_FANTASIA');
  sql.Add('  FROM pessoa');
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    pessoaConsultado.Destroy;
    pessoaConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    pessoaConsultado.FCodigo := query.FieldByName('CODIGO_PESSOA').Value;
    pessoaConsultado.FNomeFantasia := query.FieldByName('NOME_FANTASIA').Value;
  end;

  Result := pessoaConsultado;

  FreeAndNil(sql);
end;

function TPessoa.consultarCodigo(codigo: integer): TPessoa;
var
  query: TZQuery;
  sql: TStringList;
  pessoaConsultado: TPessoa;
begin
  sql := TStringList.Create;
  sql.Add('SELECT pessoa.CODIGO_PESSOA, pessoa.CODIGO_TIPO_PESSOA, pessoa.CODIGO_TIPO_DOCUMENTO, pessoa.DOCUMENTO');
  sql.Add(', pessoa.RAZAO_SOCIAL, pessoa.NOME_FANTASIA, pessoa.TELEFONE, pessoa.EMAIL, pessoa.SENHA, pessoa.OBSERVACAO');
  sql.Add(', pessoa.CODIGO_SESSAO_CADASTRO, pessoa.CODIGO_SESSAO_ALTERACAO, pessoa.DATA_CADASTRO, pessoa.DATA_ULTIMA_ALTERACAO');
  sql.Add(', pessoa.`STATUS`, tipo_documento.DESCRICAO, tipo_documento.QTDE_CARACTERES, tipo_documento.MASCARA_CARACTERES');
  sql.Add('');
  sql.Add(', (SELECT p2.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa p2, sessao ');
  sql.Add('    WHERE p2.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT p2.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa p2, sessao ');
  sql.Add('    WHERE p2.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM pessoa, tipo_documento');
  sql.Add(' WHERE pessoa.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');
  sql.Add('   AND pessoa.CODIGO_PESSOA = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    pessoaConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    pessoaConsultado := montarPessoa(query);
  end;

  Result := pessoaConsultado;
  FreeAndNil(sql);
end;

function TPessoa.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(pessoa.CODIGO_PESSOA) TOTAL');
  sql.Add('  FROM pessoa, tipo_documento');
  sql.Add(' WHERE pessoa.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO ');

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND pessoa.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
  end;

  if  (FTipoCadastro.id > 0) then
  begin
    sql.Add('   AND pessoa.CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));
  end;

  if  (FTipoDocumento.id > 0) then
  begin
    sql.Add('   AND pessoa.CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
  end;

  if  (FTipoDocumento.descricao <> '') then
  begin
    sql.Add('   AND tipo_documento.DESCRICAO LIKE ' + QuotedStr('%' + FTipoDocumento.descricao + '%'));
  end;

  if  (FDocumento <> '') then
  begin
    sql.Add('   AND pessoa.DOCUMENTO LIKE ' + QuotedStr('%' + FDocumento + '%'));
  end;

  if  (FRazaoSocial <> '') then
  begin
    sql.Add('   AND pessoa.RAZAO_SOCIAL LIKE ' + QuotedStr('%' + FRazaoSocial + '%'));
  end;

  if  (FNomeFantasia <> '') then
  begin
    sql.Add('   AND pessoa.NOME_FANTASIA LIKE ' + QuotedStr('%' + FNomeFantasia + '%'));
  end;

  if  (FTelefone <> '') then
  begin
    sql.Add('   AND pessoa.TELEFONE LIKE ' + QuotedStr('%' + FTelefone + '%'));
  end;

  if  (FEmail <> '') then
  begin
    sql.Add('   AND pessoa.EMAIL LIKE ' + QuotedStr('%' + FEmail + '%'));
  end;

  if  (FObservacao <> '') then
  begin
    sql.Add('   AND pessoa.OBSERVACAO LIKE ' + QuotedStr('%' + FObservacao + '%'));
  end;

  sql.Add('   AND pessoa.`STATUS` = ' + QuotedStr(FStatus));

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

constructor TPessoa.Create;
begin
  FTipoCadastro := TTipoPessoa.Create;
  FTipoDocumento := TTipoDocumento.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TPessoa.Destroy;
begin
  if Assigned(FTipoCadastro) then
  begin
    FTipoCadastro.Destroy;
  end;

  if Assigned(FTipoDocumento) then
  begin
    FTipoDocumento.Destroy;
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

function TPessoa.excluirCadastro: Boolean;
var
  sql: TStringList;
  resposta: boolean;
begin
  sql := TStringList.Create;
  resposta := True;

  if (resposta = True) then
  try
    sql.Clear;
    sql.Add('DELETE FROM pessoa_contato');
    sql.Add(' WHERE pessoa_contato.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
    sql.Add('   AND pessoa_contato.`STATUS` = ''I'' ');
    FConexao.executarComandoDML(sql.Text);
    resposta := True;
  except
    on E: Exception do
    begin
      resposta := False;
    end;
  end;

  if (resposta = True) then
  try
    sql.Clear;
    sql.Add('DELETE FROM pessoa_endereco');
    sql.Add(' WHERE pessoa_endereco.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
    sql.Add('   AND pessoa_endereco.`STATUS` = ''I'' ');
    FConexao.executarComandoDML(sql.Text);
    resposta := True;
  except
    on E: Exception do
    begin
      resposta := False;
    end;
  end;

  if (resposta = True) then
  try
    sql.Clear;
    sql.Add('DELETE FROM pessoa_outro_documento');
    sql.Add(' WHERE pessoa_outro_documento.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
    sql.Add('   AND pessoa_outro_documento.`STATUS` = ''I'' ');
    FConexao.executarComandoDML(sql.Text);
    resposta := True;
  except
    on E: Exception do
    begin
      resposta := False;
    end;
  end;

  if (resposta = True) then
  try
    sql.Clear;
    sql.Add('DELETE FROM `pessoa`');
    sql.Add(' WHERE `pessoa`.CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
    sql.Add('   AND CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));
    FConexao.executarComandoDML(sql.Text);
    resposta := True;
  except
    on E: Exception do
    begin
      resposta := False;
    end;
  end;

  Result := resposta;
  FreeAndNil(sql);
end;

function TPessoa.existeRegistro: TPessoa;
var
  query: TZQuery;
  pessoaConsultado: TPessoa;
  sql: TStringList;
begin
  pessoaConsultado := TPessoa.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PESSOA, NOME_FANTASIA, `STATUS`');
  sql.Add('  FROM pessoa');
  sql.Add(' WHERE DOCUMENTO = ' + QuotedStr(trim(soNumeros(FDocumento))));
  sql.Add('   AND CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));
  sql.Add('   AND CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_PESSOA <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    pessoaConsultado.Destroy;
    pessoaConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    pessoaConsultado.FCodigo := query.FieldByName('CODIGO_PESSOA').Value;
    pessoaConsultado.FNomeFantasia := query.FieldByName('NOME_FANTASIA').Value;
    pessoaConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := pessoaConsultado;

  FreeAndNil(sql);
end;

function TPessoa.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TPessoa.inativarPessoa: TPessoa;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FTipoCadastro.id));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TPessoa.limpar;
begin
  FCodigo := 0;
  FTipoCadastro.limpar;
  FTipoDocumento.limpar;
  FDocumento := '';
  FRazaoSocial := '';
  FNomeFantasia := '';
  FTelefone := '';
  FEmail := '';
  FSenha := '';
  FObservacao := '';
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

function TPessoa.montarPessoa(query: TZQuery): TPessoa;
var
  data: TPessoa;
begin
  try
    data := TPessoa.Create;

    data.FCodigo := query.FieldByName('CODIGO_PESSOA').Value;
    data.FTipoCadastro.id := query.FieldByName('CODIGO_TIPO_PESSOA').Value;
    data.FTipoDocumento.id := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    data.FTipoDocumento.descricao := query.FieldByName('DESCRICAO').Value;
    data.FTipoDocumento.qtdeCaracteres := query.FieldByName('QTDE_CARACTERES').Value;
    data.FTipoDocumento.mascara := query.FieldByName('MASCARA_CARACTERES').Value;
    data.FDocumento := query.FieldByName('DOCUMENTO').Value;
    data.FRazaoSocial := query.FieldByName('RAZAO_SOCIAL').Value;
    data.FNomeFantasia := query.FieldByName('NOME_FANTASIA').Value;
    data.FTelefone := query.FieldByName('TELEFONE').Value;
    data.FEmail := query.FieldByName('EMAIL').Value;
    data.FSenha := query.FieldByName('SENHA').Value;
    data.FObservacao := query.FieldByName('OBSERVACAO').AsString;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Pessoa ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TPessoa.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
