unit Model.Funcao;

interface

uses system.SysUtils, Model.Sessao, ZDataset, System.Classes;

type TFuncao = class

  private
    FCodigo: integer;
    FDescricao: string;
    FValorHoraNormal: Double;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

    function calcularHora50: Double;
    function calcularHora100: Double;
    function calcularHoraAdNoturno: Double;
    function contar: integer;
    function montarFuncao(query: TZQuery): TFuncao;
    function consultarCodigo(codigo: integer): TFuncao;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property descricao: string read FDescricao write FDescricao;
    property valorHoraNormal: Double read FValorHoraNormal write FValorHoraNormal;
    property valorHora50: Double read calcularHora50;
    property valorHora100: Double read calcularHora100;
    property valorAdicionalNoturno: Double read calcularHoraAdNoturno;
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

    function consultar: TArray<TFuncao>;
    function consultarChave: TFuncao;
    function existeRegistro: TFuncao;
    function cadastrarFuncao: TFuncao;
    function alterarFuncao: TFuncao;
    function inativarFuncao: TFuncao;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
    function buscarRegistroCadastrar(descricao: string): integer;
end;

implementation

uses UFuncao, Principal;

{ TFuncao }

function TFuncao.alterarFuncao: TFuncao;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `funcao`');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , `VALOR_HORA_NORMAL` = ' + VirgulaPonto(FValorHoraNormal));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_FUNCAO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TFuncao.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TFuncao.buscarRegistroCadastrar(descricao: string): integer;
var
  funcaoConsultado: TFuncao;
begin
  FDescricao := descricao;
  funcaoConsultado := existeRegistro;

  if Assigned(funcaoConsultado) then
  begin
    Result := funcaoConsultado.id;
    funcaoConsultado.Destroy;
  end
  else
  begin
    funcaoConsultado := cadastrarFuncao;
    Result := funcaoConsultado.id;
    funcaoConsultado.Destroy;
  end;
end;

function TFuncao.cadastrarFuncao: TFuncao;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('funcao', 'CODIGO_FUNCAO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `funcao` (`CODIGO_FUNCAO`, `DESCRICAO`');
  sql.Add(',`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`');
  sql.Add(', `VALOR_HORA_NORMAL`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_FUNCAO
  sql.Add(',' + QuotedStr(FDescricao));                                         //DESCRICAO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(',' + VirgulaPonto(FValorHoraNormal));                                //VALOR_HORA_NORMAL
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TFuncao.calcularHora100: Double;
begin
  Result := ((FValorHoraNormal / 100) * 100) + FValorHoraNormal;
end;

function TFuncao.calcularHora50: Double;
begin
  Result := ((FValorHoraNormal / 100) * 50) + FValorHoraNormal;
end;

function TFuncao.calcularHoraAdNoturno: Double;
begin
  Result := ((FValorHoraNormal / 100) * 20) + FValorHoraNormal;
end;

function TFuncao.consultar: TArray<TFuncao>;
var
  query: TZQuery;
  Funcoes: TArray<TFuncao>;
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
    sql.Add('SELECT funcao.CODIGO_FUNCAO, funcao.DESCRICAO, funcao.CODIGO_SESSAO_CADASTRO');
    sql.Add(', funcao.CODIGO_SESSAO_ALTERACAO, funcao.DATA_CADASTRO, funcao.DATA_ULTIMA_ALTERACAO');
    sql.Add(', funcao.`STATUS`, funcao.`VALOR_HORA_NORMAL`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = funcao.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = funcao.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM funcao');
    sql.Add(' WHERE funcao.`STATUS` = ' + QuotedStr(FStatus));

    if (FDescricao <> '') then
    begin
      sql.Add('   AND funcao.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND funcao.CODIGO_FUNCAO = ' + IntToStrSenaoZero(FCodigo));
    end;

    if  (FValorHoraNormal > 0) then
    begin
      sql.Add('   AND funcao.VALOR_HORA_NORMAL = ' + VirgulaPonto(FValorHoraNormal));
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
        Funcoes[contador] := montarFuncao(query);
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

function TFuncao.consultarChave: TFuncao;
var
  query: TZQuery;
  funcaoConsultado: TFuncao;
  sql: TStringList;
begin
  funcaoConsultado := TFuncao.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_FUNCAO, DESCRICAO');
  sql.Add('  FROM funcao');
  sql.Add(' WHERE CODIGO_FUNCAO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    funcaoConsultado.Destroy;
    funcaoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    funcaoConsultado.FCodigo := query.FieldByName('CODIGO_FUNCAO').Value;
    funcaoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := funcaoConsultado;

  FreeAndNil(sql);
end;

function TFuncao.consultarCodigo(codigo: integer): TFuncao;
var
  query: TZQuery;
  sql: TStringList;
  funcaoConsultado: TFuncao;
begin
  sql := TStringList.Create;
  sql.Add('SELECT funcao.CODIGO_FUNCAO, funcao.DESCRICAO, funcao.CODIGO_SESSAO_CADASTRO');
  sql.Add(', funcao.CODIGO_SESSAO_ALTERACAO, funcao.DATA_CADASTRO, funcao.DATA_ULTIMA_ALTERACAO');
  sql.Add(', funcao.`STATUS`, funcao.`VALOR_HORA_NORMAL`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = funcao.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = funcao.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM funcao');
  sql.Add(' WHERE funcao.CODIGO_FUNCAO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    funcaoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    funcaoConsultado := montarFuncao(query);
  end;

  Result := funcaoConsultado;
  FreeAndNil(sql);
end;

function TFuncao.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(funcao.CODIGO_FUNCAO) TOTAL');
  sql.Add('  FROM funcao');
  sql.Add(' WHERE funcao.`STATUS` = ' + QuotedStr(FStatus));

  if (FDescricao <> '') then
  begin
    sql.Add('   AND funcao.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND funcao.CODIGO_FUNCAO = ' + IntToStrSenaoZero(FCodigo));
  end;

  if  (FValorHoraNormal > 0) then
  begin
    sql.Add('   AND funcao.VALOR_HORA_NORMAL = ' + VirgulaPonto(FValorHoraNormal));
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

constructor TFuncao.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

destructor TFuncao.Destroy;
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

function TFuncao.existeRegistro: TFuncao;
var
  query: TZQuery;
  funcaoConsultado: TFuncao;
  sql: TStringList;
begin
  funcaoConsultado := TFuncao.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_FUNCAO, DESCRICAO, `STATUS`');
  sql.Add('  FROM funcao');
  sql.Add(' WHERE DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_FUNCAO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    funcaoConsultado.Destroy;
    funcaoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    funcaoConsultado.FCodigo := query.FieldByName('CODIGO_FUNCAO').Value;
    funcaoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    funcaoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := funcaoConsultado;

  FreeAndNil(sql);
end;

function TFuncao.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TFuncao.inativarFuncao: TFuncao;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `funcao`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_FUNCAO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TFuncao.limpar;
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
  FValorHoraNormal := 0;
  FRegistrosAfetados := 0;
  FMaisRegistro := False;
end;

function TFuncao.montarFuncao(query: TZQuery): TFuncao;
var
  data: TFuncao;
begin
  try
    data := TFuncao.Create;

    data.FCodigo := query.FieldByName('CODIGO_FUNCAO').Value;
    data.FDescricao := query.FieldByName('DESCRICAO').Value;
    data.FValorHoraNormal := query.FieldByName('VALOR_HORA_NORMAL').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Função ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TFuncao.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
