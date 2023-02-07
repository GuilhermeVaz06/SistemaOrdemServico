unit Model.Cidade;

interface

uses Model.Sessao, Model.Estado, System.SysUtils, ZDataset, System.Classes;

type TCidade = class

  private
    FCodigo: integer;
    FEstado: TEstado;
    FCodigoIbge: string;
    FNome: string;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property estado: TEstado read FEstado write FEstado;
    property codigoIbge: string read FCodigoIbge write FCodigoIbge;
    property nome: string read FNome write FNome;
    property cadastradoPor: TSessao read FCadastradoPor write FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor write FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus write FStatus;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;

    procedure limpar;
    procedure atualizarLog(codigo: Integer; resposta: string);

    function montarCidade(query: TZQuery): TCidade;
    function consultar: TArray<TCidade>;
    function consultarCodigo(codigo: integer): TCidade;
    function consultarChave: TCidade;
    function existeRegistro: TCidade;
    function contar: integer;
    function cadastrarCidade: TCidade;
    function alterarCidade: TCidade;
    function inativarCidade: TCidade;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TCidade }

constructor TCidade.Create;
begin
  FEstado := TEstado.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TCidade.Destroy;
begin
  if Assigned(FEstado) then
  begin
    FEstado.Destroy;
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

function TCidade.existeRegistro: TCidade;
var
  query: TZQuery;
  cidadeConsultado: TCidade;
  sql: TStringList;
begin
  cidadeConsultado := TCidade.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_CIDADE, NOME');
  sql.Add('  FROM cidade');
  sql.Add(' WHERE (CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('    OR  NOME = ' + QuotedStr(FNome) + ')');

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_CIDADE <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    cidadeConsultado.Destroy;
    cidadeConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    cidadeConsultado.FCodigo := query.FieldByName('CODIGO_CIDADE').Value;
    cidadeConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := cidadeConsultado;

  FreeAndNil(sql);
end;

function TCidade.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

procedure TCidade.limpar;
begin
  FCodigo := 0;
  FEstado.limpar;
  FCodigoIbge := '';
  FNome := '';
  FCadastradoPor.limpar;
  FAlteradoPor.limpar;
  FDataCadastro := Now;
  FUltimaAlteracao := Now;
  FStatus := 'A';
  FLimite := 0;
  FOffset := 0;
  FRegistrosAfetados := 0;
  FMaisRegistro := False;
end;

function TCidade.montarCidade(query: TZQuery): TCidade;
var
  data: TCidade;
begin
  try
    data := TCidade.Create;

    data.FCodigo := query.FieldByName('CODIGO_CIDADE').Value;
    data.FEstado.id := query.FieldByName('CODIGO_ESTADO').Value;
    data.FEstado.nome := query.FieldByName('nomeEstado').Value;
    data.FEstado.pais.id := query.FieldByName('CODIGO_PAIS').Value;
    data.FEstado.pais.nome := query.FieldByName('nomePais').Value;
    data.FCodigoIbge := query.FieldByName('CODIGO_IBGE').Value;
    data.FNome := query.FieldByName('NOME').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Cidade ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TCidade.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TCidade.alterarCidade: TCidade;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `cidade`');
  sql.Add('   SET CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('     , NOME = ' + QuotedStr(FNome));
  sql.Add('     , CODIGO_ESTADO = ' + IntToStrSenaoZero(FEstado.id));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_CIDADE = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TCidade.inativarCidade: TCidade;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `cidade`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_CIDADE = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TCidade.atualizarLog(codigo: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, resposta);
end;

function TCidade.cadastrarCidade: TCidade;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('cidade', 'CODIGO_CIDADE');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `cidade` (`CODIGO_ESTADO`, `CODIGO_CIDADE`, `CODIGO_IBGE`, `NOME`, ');
  sql.Add('`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FEstado.id));                                 //CODIGO_ESTADO
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_CIDADE
  sql.Add(',' + QuotedStr(FCodigoIbge));                                        //CODIGO_IBGE
  sql.Add(',' + QuotedStr(FNome));                                              //NOME
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TCidade.consultar: TArray<TCidade>;
var
  query: TZQuery;
  cidades: TArray<TCidade>;
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
    sql.Add('SELECT cidade.CODIGO_ESTADO, cidade.CODIGO_CIDADE, cidade.CODIGO_IBGE, cidade.NOME');
    sql.Add(', cidade.CODIGO_SESSAO_CADASTRO, cidade.CODIGO_SESSAO_ALTERACAO, pais.CODIGO_PAIS');
    sql.Add(', cidade.DATA_CADASTRO, cidade.DATA_ULTIMA_ALTERACAO, cidade.`STATUS`');
    sql.Add(', pais.NOME nomePais, estado.NOME nomeEstado');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = cidade.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = cidade.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM cidade, estado, pais');
    sql.Add(' WHERE pais.CODIGO_PAIS = estado.CODIGO_PAIS');
    sql.Add('   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO');

    if (FCodigoIbge <> '') then
    begin
      sql.Add('   AND cidade.CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
    end;

    if  (FNome <> '') then
    begin
      sql.Add('   AND cidade.NOME LIKE ' + QuotedStr('%' + FNome + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND cidade.CODIGO_CIDADE = ' + IntToStrSenaoZero(FCodigo));
    end;

    if  (FEstado.id > 0) then
    begin
      sql.Add('   AND cidade.CODIGO_ESTADO = ' + IntToStrSenaoZero(FEstado.id));
    end;

    if  (FEstado.nome <> '') then
    begin
      sql.Add('   AND estado.NOME LIKE ' + QuotedStr('%' + FEstado.nome + '%'));
    end;

    if  (FEstado.pais.id > 0) then
    begin
      sql.Add('   AND pais.CODIGO_PAIS = ' + IntToStrSenaoZero(FEstado.pais.id));
    end;

    if  (FEstado.pais.nome <> '') then
    begin
      sql.Add('   AND pais.NOME LIKE ' + QuotedStr('%' + FEstado.pais.nome + '%'));
    end;

    sql.Add('   AND cidade.`STATUS` = ' + QuotedStr(FStatus));
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
      SetLength(cidades, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        cidades[contador] := montarCidade(query);
        query.Next;
        inc(contador);
      end;

      Result := cidades;
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

function TCidade.consultarChave: TCidade;
var
  query: TZQuery;
  cidadeConsultado: TCidade;
  sql: TStringList;
begin
  cidadeConsultado := TCidade.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_CIDADE, NOME');
  sql.Add('  FROM cidade');
  sql.Add(' WHERE CODIGO_CIDADE = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    cidadeConsultado.Destroy;
    cidadeConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    cidadeConsultado.FCodigo := query.FieldByName('CODIGO_CIDADE').Value;
    cidadeConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := cidadeConsultado;

  FreeAndNil(sql);
end;

function TCidade.consultarCodigo(codigo: integer): TCidade;
var
  query: TZQuery;
  sql: TStringList;
  cidadeConsultado: TCidade;
begin
  sql := TStringList.Create;
  sql.Add('SELECT cidade.CODIGO_ESTADO, cidade.CODIGO_CIDADE, cidade.CODIGO_IBGE, cidade.NOME');
  sql.Add(', cidade.CODIGO_SESSAO_CADASTRO, cidade.CODIGO_SESSAO_ALTERACAO, pais.CODIGO_PAIS');
  sql.Add(', cidade.DATA_CADASTRO, cidade.DATA_ULTIMA_ALTERACAO, cidade.`STATUS`');
  sql.Add(', pais.NOME nomePais, estado.NOME nomeEstado');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = cidade.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = cidade.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM cidade, estado, pais');
  sql.Add(' WHERE cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO');
  sql.Add('   AND pais.CODIGO_PAIS = estado.CODIGO_PAIS');
  sql.Add('   AND cidade.CODIGO_CIDADE = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    cidadeConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    cidadeConsultado := montarCidade(query);
  end;

  Result := cidadeConsultado;
  FreeAndNil(sql);
end;

function TCidade.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(cidade.CODIGO_CIDADE) TOTAL');
  sql.Add('  FROM cidade, estado, pais');
  sql.Add(' WHERE 1 = 1');

  if (FCodigoIbge <> '') then
  begin
    sql.Add('   AND cidade.CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
  end;

  if  (FNome <> '') then
  begin
    sql.Add('   AND cidade.NOME LIKE ' + QuotedStr('%' + FNome + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND cidade.CODIGO_CIDADE = ' + IntToStrSenaoZero(FCodigo));
  end;

  if  (FEstado.id > 0) then
  begin
    sql.Add('   AND cidade.CODIGO_ESTADO = ' + IntToStrSenaoZero(FEstado.id));
  end;

  if  (FEstado.nome <> '') then
  begin
    sql.Add('   AND estado.NOME LIKE ' + QuotedStr('%' + FEstado.nome + '%'));
  end;

  if  (FEstado.pais.id > 0) then
  begin
    sql.Add('   AND pais.CODIGO_PAIS = ' + IntToStrSenaoZero(FEstado.pais.id));
  end;

  if  (FEstado.pais.nome <> '') then
  begin
    sql.Add('   AND pais.NOME LIKE ' + QuotedStr('%' + FEstado.pais.nome + '%'));
  end;

  sql.Add('   AND cidade.`STATUS` = ' + QuotedStr(FStatus));
  sql.Add('   AND pais.CODIGO_PAIS = estado.CODIGO_PAIS');
  sql.Add('   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO');

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

end.
