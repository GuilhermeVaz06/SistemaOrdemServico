unit Model.Pessoa.Contato;

interface

uses Model.Sessao, Model.TipoDocumento, Model.Pessoa, System.SysUtils,
     ZDataset, System.Classes;

type TContato = class

  private
    FCodigo: integer;
    FPessoa: TPessoa;
    FTipoDocumento: TTipoDocumento;
    FDocumento: string;
    FNome: string;
    FDataNascimento: TDateTime;
    FFuncao: string;
    FTelefone: string;
    FEmail: string;
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
    function consulxtarCodigo(codigo: integer): TContato;
    function montarContato(query: TZQuery): TContato;
    function consultarCodigo(codigo: integer): TContato;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property pessoa: TPessoa read FPessoa write FPessoa;
    property tipoDocumento: TTipoDocumento read FTipoDocumento write FTipoDocumento;
    property documento: string read FObservacao write FObservacao;
    property observacao: string read FDocumento write FDocumento;
    property nome: string read FNome write FNome;
    property dataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property funcao: string read FFuncao write FFuncao;
    property telefone: string read FTelefone write FTelefone;
    property email: string read FEmail write FEmail;
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

    function consultar: TArray<TContato>;
    function consultarChave: TContato;
    function existeRegistro: TContato;
    function cadastrarContato: TContato;
    function alterarContato: TContato;
    function inativarContato: TContato;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TContato }

destructor TContato.Destroy;
begin
  if Assigned(FPessoa) then
  begin
    FPessoa.Destroy;
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

function TContato.existeRegistro: TContato;
var
  query: TZQuery;
  contatoConsultado: TContato;
  sql: TStringList;
begin
  contatoConsultado := TContato.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_CONTATO, NOME, `STATUS`');
  sql.Add('  FROM pessoa_contato');
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  sql.Add('   AND NOME = ' + QuotedStr(FNome));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_CONTATO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    contatoConsultado.Destroy;
    contatoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    contatoConsultado.FCodigo := query.FieldByName('CODIGO_CONTATO').Value;
    contatoConsultado.FNome := query.FieldByName('NOME').Value;
    contatoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := contatoConsultado;

  FreeAndNil(sql);
end;

function TContato.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TContato.inativarContato: TContato;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_contato`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_CONTATO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TContato.limpar;
begin
  FCodigo := 0;
  FPessoa.limpar;
  FTipoDocumento.limpar;
  FDocumento := '';
  FNome := '';
  FDataNascimento := Now;
  FFuncao := '';
  FTelefone := '';
  FEmail := '';
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

function TContato.montarContato(query: TZQuery): TContato;
var
  data: TContato;
begin
  try
    data := TContato.Create;

    data.FCodigo := query.FieldByName('CODIGO_CONTATO').Value;
    data.FPessoa.id := query.FieldByName('CODIGO_PESSOA').Value;
    data.FTipoDocumento.id := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    data.FTipoDocumento.descricao := query.FieldByName('nomeDocumento').Value;
    data.FTipoDocumento.mascara := query.FieldByName('mascaraCararteres').Value;
    data.FDocumento := query.FieldByName('DOCUMENTO').Value;
    data.FNome := query.FieldByName('NOME').Value;
    data.FDataNascimento := query.FieldByName('DATA_NASCIMENTO').Value;
    data.FFuncao := query.FieldByName('FUNCAO').Value;
    data.FTelefone := query.FieldByName('TELEFONE').Value;
    data.FEmail := query.FieldByName('EMAIL').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Contato ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TContato.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TContato.alterarContato: TContato;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_contato` ');
  sql.Add('   SET CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
  sql.Add('     , DOCUMENTO = ' + QuotedStr(soNumeros(Trim(FDocumento))));
  sql.Add('     , NOME = ' + QuotedStr(FNome));
  sql.Add('     , DATA_NASCIMENTO = ' + DataBD(FDataNascimento));
  sql.Add('     , FUNCAO = ' + QuotedStr(FFuncao));
  sql.Add('     , TELEFONE = ' + QuotedStr(FTelefone));
  sql.Add('     , OBSERVACAO = ' + QuotedStr(FObservacao));
  sql.Add('     , EMAIL = ' + QuotedStr(FEmail));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TContato.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TContato.cadastrarContato: TContato;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('pessoa_contato', 'CODIGO_CONTATO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `pessoa_endereco` (CODIGO_PESSOA, CODIGO_CONTATO, CODIGO_TIPO_DOCUMENTO');
  sql.Add(', DOCUMENTO, NOME, DATA_NASCIMENTO, FUNCAO, TELEFONE, OBSERVACAO');
  sql.Add(', EMAIL, CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FPessoa.id));                                 //CODIGO_PESSOA
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_CONTATO
  sql.Add(',' + IntToStrSenaoZero(FTipoDocumento.id));                          //CODIGO_TIPO_DOCUMENTO
  sql.Add(',' + QuotedStr(soNumeros(Trim(FDocumento))));                        //DOCUMENTO
  sql.Add(',' + QuotedStr(FNome));                                              //NOME
  sql.Add(',' + DataBD(FDataNascimento));                                       //DATA_NASCIMENTO
  sql.Add(',' + QuotedStr(FFuncao));                                            //FUNCAO
  sql.Add(',' + QuotedStr(FTelefone));                                          //TELEFONE
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + QuotedStr(email));                                              //EMAIL
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TContato.consultar: TArray<TContato>;
var
  query: TZQuery;
  contatos: TArray<TContato>;
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
    sql.Add('SELECT pessoa_contato.CODIGO_PESSOA, pessoa_contato.CODIGO_CONTATO, pessoa_contato.CODIGO_TIPO_DOCUMENTO');
    sql.Add(', pessoa_contato.DOCUMENTO, pessoa_contato.NOME, pessoa_contato.DATA_NASCIMENTO, pessoa_contato.FUNCAO');
    sql.Add(', pessoa_contato.TELEFONE, pessoa_contato.EMAIL, pessoa_contato.CODIGO_SESSAO_CADASTRO');
    sql.Add(', pessoa_contato.CODIGO_SESSAO_ALTERACAO, pessoa_contato.DATA_CADASTRO, pessoa_contato.DATA_ULTIMA_ALTERACAO');
    sql.Add(', pessoa_contato.`STATUS`, tipo_documento.DESCRICAO nomeDocumento, tipo_documento.MASCARA_CARACTERES mascaraCararteres');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_contato.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_contato.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM pessoa_contato, tipo_documento');
    sql.Add(' WHERE pessoa_contato.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');

    if (FPessoa.id > 0) then
    begin
      sql.Add('   AND pessoa_contato.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND pessoa_contato.CODIGO_CONTATO = ' + IntToStrSenaoZero(FCodigo));
    end;

    sql.Add('   AND pessoa_contato.`STATUS` = ' + QuotedStr(FStatus));
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
      SetLength(contatos, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        contatos[contador] := montarContato(query);
        query.Next;
        inc(contador);
      end;

      Result := contatos;
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

function TContato.consultarChave: TContato;
var
  query: TZQuery;
  contatoConsultado: TContato;
  sql: TStringList;
begin
  contatoConsultado := TContato.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_CONTATO, NOME');
  sql.Add('  FROM pessoa_contato');
  sql.Add(' WHERE CODIGO_CONTATO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    contatoConsultado.Destroy;
    contatoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    contatoConsultado.FCodigo := query.FieldByName('CODIGO_CONTATO').Value;
    contatoConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := contatoConsultado;

  FreeAndNil(sql);
end;

function TContato.consultarCodigo(codigo: integer): TContato;
var
  query: TZQuery;
  sql: TStringList;
  contatoConsultado: TContato;
begin
  sql := TStringList.Create;
  sql.Add('SELECT pessoa_contato.CODIGO_PESSOA, pessoa_contato.CODIGO_CONTATO, pessoa_contato.CODIGO_TIPO_DOCUMENTO');
  sql.Add(', pessoa_contato.DOCUMENTO, pessoa_contato.NOME, pessoa_contato.DATA_NASCIMENTO, pessoa_contato.FUNCAO');
  sql.Add(', pessoa_contato.TELEFONE, pessoa_contato.EMAIL, pessoa_contato.CODIGO_SESSAO_CADASTRO');
  sql.Add(', pessoa_contato.CODIGO_SESSAO_ALTERACAO, pessoa_contato.DATA_CADASTRO, pessoa_contato.DATA_ULTIMA_ALTERACAO');
  sql.Add(', pessoa_contato.`STATUS`, tipo_documento.DESCRICAO nomeDocumento, tipo_documento.MASCARA_CARACTERES mascaraCararteres');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_contato.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_contato.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM pessoa_contato, tipo_documento');
  sql.Add(' WHERE pessoa_contato.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');
  sql.Add('   AND pessoa_endereco.CODIGO_ENDERECO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    contatoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    contatoConsultado := montarContato(query);
  end;

  Result := contatoConsultado;
  FreeAndNil(sql);
end;

function TContato.consulxtarCodigo(codigo: integer): TContato;
begin

end;

function TContato.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(pessoa_contato.CODIGO_CONTATO) TOTAL');
  sql.Add('  FROM pessoa_contato, tipo_documento');
  sql.Add(' WHERE pessoa_contato.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO ');

  if (FPessoa.id > 0) then
  begin
    sql.Add('   AND pessoa_contato.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND pessoa_contato.CODIGO_CONTATO = ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add('   AND pessoa_contato.`STATUS` = ' + QuotedStr(FStatus));

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

constructor TContato.Create;
begin
  FPessoa := TPessoa.Create;
  FTipoDocumento := TTipoDocumento.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

end.
