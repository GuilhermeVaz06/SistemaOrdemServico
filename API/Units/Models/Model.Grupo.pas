unit Model.Grupo;

interface

uses system.SysUtils, Model.Sessao, ZDataset, System.Classes;

type TGrupo = class

  private
    FCodigo: integer;
    FDescricao: string;
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
    function montarGrupo(query: TZQuery): TGrupo;
    function consultarCodigo(codigo: integer): TGrupo;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property descricao: string read FDescricao write FDescricao;
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

    function consultar: TArray<TGrupo>;
    function consultarChave: TGrupo;
    function existeRegistro: TGrupo;
    function cadastrarGrupo: TGrupo;
    function alterarGrupo: TGrupo;
    function inativarGrupo: TGrupo;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses UFuncao, Principal;

{ TGrupo }

function TGrupo.alterarGrupo: TGrupo;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `grupo`');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TGrupo.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TGrupo.cadastrarGrupo: TGrupo;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('grupo', 'CODIGO_GRUPO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `grupo` (`CODIGO_GRUPO`, `DESCRICAO`');
  sql.Add(',`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_GRUPO
  sql.Add(',' + QuotedStr(FDescricao));                                         //DESCRICAO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TGrupo.consultar: TArray<TGrupo>;
var
  query: TZQuery;
  Funcoes: TArray<TGrupo>;
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
    sql.Add('SELECT grupo.CODIGO_GRUPO, grupo.DESCRICAO, grupo.CODIGO_SESSAO_CADASTRO');
    sql.Add(', grupo.CODIGO_SESSAO_ALTERACAO, grupo.DATA_CADASTRO, grupo.DATA_ULTIMA_ALTERACAO');
    sql.Add(', grupo.`STATUS`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM grupo');
    sql.Add(' WHERE grupo.`STATUS` = ' + QuotedStr(FStatus));

    if (FDescricao <> '') then
    begin
      sql.Add('   AND grupo.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND grupo.CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
    end;

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
      SetLength(Funcoes, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        Funcoes[contador] := montarGrupo(query);
        query.Next;
        inc(contador);
      end;

      Result := Funcoes;
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

function TGrupo.consultarChave: TGrupo;
var
  query: TZQuery;
  grupoConsultado: TGrupo;
  sql: TStringList;
begin
  grupoConsultado := TGrupo.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_GRUPO, DESCRICAO');
  sql.Add('  FROM grupo');
  sql.Add(' WHERE CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    grupoConsultado.Destroy;
    grupoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    grupoConsultado.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
    grupoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := grupoConsultado;

  FreeAndNil(sql);
end;

function TGrupo.consultarCodigo(codigo: integer): TGrupo;
var
  query: TZQuery;
  sql: TStringList;
  grupoConsultado: TGrupo;
begin
  sql := TStringList.Create;
  sql.Add('SELECT grupo.CODIGO_GRUPO, grupo.DESCRICAO, grupo.CODIGO_SESSAO_CADASTRO');
  sql.Add(', grupo.CODIGO_SESSAO_ALTERACAO, grupo.DATA_CADASTRO, grupo.DATA_ULTIMA_ALTERACAO');
  sql.Add(', grupo.`STATUS`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM grupo');
  sql.Add(' WHERE grupo.CODIGO_GRUPO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    grupoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    grupoConsultado := montarGrupo(query);
  end;

  Result := grupoConsultado;
  FreeAndNil(sql);
end;

function TGrupo.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(grupo.CODIGO_GRUPO) TOTAL');
  sql.Add('  FROM grupo');
  sql.Add(' WHERE grupo.`STATUS` = ' + QuotedStr(FStatus));

  if (FDescricao <> '') then
  begin
    sql.Add('   AND grupo.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND grupo.CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
  end;

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

constructor TGrupo.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

destructor TGrupo.Destroy;
begin
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

function TGrupo.existeRegistro: TGrupo;
var
  query: TZQuery;
  grupoConsultado: TGrupo;
  sql: TStringList;
begin
  grupoConsultado := TGrupo.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_GRUPO, DESCRICAO, `STATUS`');
  sql.Add('  FROM grupo');
  sql.Add(' WHERE DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_GRUPO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    grupoConsultado.Destroy;
    grupoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    grupoConsultado.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
    grupoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    grupoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := grupoConsultado;

  FreeAndNil(sql);
end;

function TGrupo.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TGrupo.inativarGrupo: TGrupo;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `grupo`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TGrupo.limpar;
begin
  FCodigo := 0;
  FDescricao := '';
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

function TGrupo.montarGrupo(query: TZQuery): TGrupo;
var
  data: TGrupo;
begin
  try
    data := TGrupo.Create;

    data.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
    data.FDescricao := query.FieldByName('DESCRICAO').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Grupo ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TGrupo.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
