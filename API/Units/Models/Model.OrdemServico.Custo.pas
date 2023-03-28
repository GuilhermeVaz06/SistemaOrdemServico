unit Model.OrdemServico.Custo;

interface

uses Model.Sessao, System.SysUtils, Model.OrdemServico, Model.Grupo, ZDataset, System.Classes;

type TCusto = class

  private
    FCodigo: integer;
    FOrdemServico: TOrdemServico;
    FGrupo: TGrupo;
    FQuantidade: Double;
    FValorUnitario: Double;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

    function calculaValorTotal: Double;
    function contar: integer;
    function montarCusto(query: TZQuery): TCusto;
    function consultarCodigo(codigo: integer): TCusto;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property ordemServico: TOrdemServico read FOrdemServico write FOrdemServico;
    property grupo: TGrupo read FGrupo write FGrupo;
    property quantidade: Double read FQuantidade write FQuantidade;
    property valorUnitario: Double read FValorUnitario write FValorUnitario;
    property valorTotal: Double read calculaValorTotal;
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

    function consultar: TArray<TCusto>;
    function consultarChave: TCusto;
    function consultarCustoAgrupado: TArray<TCusto>;
    function existeRegistro: TCusto;
    function cadastrarCusto: TCusto;
    function alterarCusto: TCusto;
    function inativarCusto: TCusto;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TCusto }

destructor TCusto.Destroy;
begin
  if Assigned(FOrdemServico) then
  begin
    FOrdemServico.Destroy;
  end;

  if Assigned(FGrupo) then
  begin
    FGrupo.Destroy;
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

function TCusto.existeRegistro: TCusto;
var
  query: TZQuery;
  custoConsultado: TCusto;
  sql: TStringList;
begin
  custoConsultado := TCusto.Create;
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_custo.CODIGO_CUSTO, grupo.DESCRICAO');
  sql.Add(', grupo.SUB_DESCRICAO, ordem_servico_custo.`STATUS`');
  sql.Add('  FROM ordem_servico_custo, grupo');
  sql.Add(' WHERE ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = ' + IntToStrSenaoZero(FGrupo.id));
  sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = grupo.CODIGO_GRUPO');

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_CUSTO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    custoConsultado.Destroy;
    custoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    custoConsultado.FCodigo := query.FieldByName('CODIGO_CUSTO').Value;
    custoConsultado.FGrupo.descricao := query.FieldByName('DESCRICAO').Value;
    custoConsultado.FGrupo.subDescricao := query.FieldByName('SUB_DESCRICAO').Value;
    custoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := custoConsultado;

  FreeAndNil(sql);
end;

function TCusto.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TCusto.inativarCusto: TCusto;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_custo`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_CUSTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TCusto.limpar;
begin
  FCodigo := 0;
  FOrdemServico.limpar;
  FGrupo.limpar;
  FQuantidade := 0;
  FValorUnitario := 0;
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

function TCusto.montarCusto(query: TZQuery): TCusto;
var
  data: TCusto;
begin
  try
    data := TCusto.Create;

    data.FOrdemServico.id := query.FieldByName('CODIGO_OS').Value;
    data.FCodigo := query.FieldByName('CODIGO_CUSTO').Value;
    data.FGrupo.id := query.FieldByName('CODIGO_GRUPO').Value;
    data.FGrupo.descricao := query.FieldByName('DESCRICAO').Value;
    data.FGrupo.subDescricao := query.FieldByName('SUB_DESCRICAO').Value;
    data.FQuantidade := query.FieldByName('QTDE').Value;
    data.FValorUnitario := query.FieldByName('VALOR_UNITARIO').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Custo ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TCusto.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TCusto.alterarCusto: TCusto;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_custo` ');
  sql.Add('   SET CODIGO_GRUPO = ' + IntToStrSenaoZero(FGrupo.id));
  sql.Add('     , QTDE = ' + VirgulaPonto(FQuantidade));
  sql.Add('     , VALOR_UNITARIO = ' + VirgulaPonto(FValorUnitario));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND CODIGO_CUSTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TCusto.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TCusto.cadastrarCusto: TCusto;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico_custo', 'CODIGO_CUSTO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico_custo` (CODIGO_OS, CODIGO_CUSTO, CODIGO_GRUPO, QTDE');
  sql.Add(', VALOR_UNITARIO, CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FOrdemServico.id));                           //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_CUSTO
  sql.Add(',' + IntToStrSenaoZero(FGrupo.id));                                  //CODIGO_GRUPO
  sql.Add(',' + VirgulaPonto(FQuantidade));                                     //QTDE
  sql.Add(',' + VirgulaPonto(FValorUnitario));                                  //VALOR_UNITARIO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;
function TCusto.calculaValorTotal: Double;
begin
  Result := FValorUnitario * FQuantidade;
end;

function TCusto.consultar: TArray<TCusto>;
var
  query: TZQuery;
  custos: TArray<TCusto>;
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
    sql.Add('SELECT ordem_servico_custo.CODIGO_OS, ordem_servico_custo.CODIGO_CUSTO, grupo.DESCRICAO');
    sql.Add(', ordem_servico_custo.QTDE, ordem_servico_custo.VALOR_UNITARIO, grupo.SUB_DESCRICAO');
    sql.Add(', ordem_servico_custo.CODIGO_SESSAO_CADASTRO, ordem_servico_custo.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', ordem_servico_custo.DATA_CADASTRO, ordem_servico_custo.DATA_ULTIMA_ALTERACAO');
    sql.Add(', ordem_servico_custo.`STATUS`, ordem_servico_custo.`CODIGO_GRUPO`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_custo.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_custo.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM ordem_servico_custo, grupo');
    sql.Add(' WHERE ordem_servico_custo.`STATUS` = ' + QuotedStr(FStatus));
    sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = grupo.CODIGO_GRUPO');

    if (FOrdemServico.id > 0) then
    begin
      sql.Add('   AND ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND ordem_servico_custo.CODIGO_CUSTO = ' + IntToStrSenaoZero(FCodigo));
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
      SetLength(custos, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        custos[contador] := montarCusto(query);
        query.Next;
        inc(contador);
      end;

      Result := custos;
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

function TCusto.consultarChave: TCusto;
var
  query: TZQuery;
  custoConsultado: TCusto;
  sql: TStringList;
begin
  custoConsultado := TCusto.Create;
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_custo.CODIGO_CUSTO, grupo.DESCRICAO, grupo.SUB_DESCRICAO');
  sql.Add('  FROM ordem_servico_custo, grupo');
  sql.Add(' WHERE CODIGO_CUSTO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = grupo.CODIGO_GRUPO');
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    custoConsultado.Destroy;
    custoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    custoConsultado.FCodigo := query.FieldByName('CODIGO_CUSTO').Value;
    custoConsultado.FGrupo.descricao := query.FieldByName('DESCRICAO').Value;
    custoConsultado.FGrupo.subDescricao := query.FieldByName('SUB_DESCRICAO').Value;
  end;

  Result := custoConsultado;

  FreeAndNil(sql);
end;

function TCusto.consultarCodigo(codigo: integer): TCusto;
var
  query: TZQuery;
  sql: TStringList;
  custoConsultado: TCusto;
begin
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_custo.CODIGO_OS, ordem_servico_custo.CODIGO_CUSTO, grupo.DESCRICAO');
  sql.Add(', ordem_servico_custo.QTDE, ordem_servico_custo.VALOR_UNITARIO, grupo.SUB_DESCRICAO');
  sql.Add(', ordem_servico_custo.CODIGO_SESSAO_CADASTRO, ordem_servico_custo.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', ordem_servico_custo.DATA_CADASTRO, ordem_servico_custo.DATA_ULTIMA_ALTERACAO');
  sql.Add(', ordem_servico_custo.`STATUS`, ordem_servico_custo.`CODIGO_GRUPO`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_custo.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_custo.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM ordem_servico_custo, grupo');
  sql.Add(' WHERE ordem_servico_custo.CODIGO_CUSTO = ' + IntToStrSenaoZero(codigo));
  sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = grupo.CODIGO_GRUPO');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    custoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    custoConsultado := montarCusto(query);
  end;

  Result := custoConsultado;
  FreeAndNil(sql);
end;

function TCusto.consultarCustoAgrupado: TArray<TCusto>;
var
  custos: TArray<TCusto>;
  contador: Integer;
  query: TZQuery;
  data: TCusto;
  sql: TStringList;
  custoConsultado: TCusto;
begin
  sql := TStringList.Create;
  sql.Add('SELECT X.DESCRICAO');
  sql.Add(', GROUP_CONCAT(DISTINCT X.SUB_DESCRICAO) SUB_DESCRICAO');
  sql.Add(', IFNULL(IFNULL(SUM(X.QTDE),0),0) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(X.VALOR_FINAL),0),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT IFNULL(ordem_servico_custo.QTDE,0) QTDE');
  sql.Add(', IFNULL(ordem_servico_custo.QTDE * ordem_servico_custo.VALOR_UNITARIO,0) VALOR_FINAL');
  sql.Add(', (SELECT grupo.DESCRICAO FROM grupo WHERE grupo.CODIGO_GRUPO = ordem_servico_custo.CODIGO_GRUPO) DESCRICAO');
  sql.Add(', (SELECT grupo.SUB_DESCRICAO FROM grupo WHERE grupo.CODIGO_GRUPO = ordem_servico_custo.CODIGO_GRUPO) SUB_DESCRICAO');
  sql.Add('  FROM ordem_servico_custo');
  sql.Add(' WHERE ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_custo.`STATUS` = ''A'') X');
  sql.Add(' GROUP BY x.DESCRICAO');
  sql.Add('');
  sql.Add(' UNION ALL');
  sql.Add(' ');
  sql.Add('SELECT ''Total Custo Geral'' DESCRICAO, '''' SUB_DESCRICAO ');
  sql.Add(', COUNT(Y.QTDE) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(Y.VALOR_FINAL),0),0) VALOR_FINAL');
  sql.Add('FROM (');
  sql.Add('SELECT COUNT(X.QTDE) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(X.VALOR_FINAL),0),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT IFNULL(ordem_servico_custo.QTDE,0) QTDE ');
  sql.Add(', IFNULL(ordem_servico_custo.QTDE * ordem_servico_custo.VALOR_UNITARIO,0) VALOR_FINAL');
  sql.Add(', (SELECT grupo.DESCRICAO FROM grupo WHERE grupo.CODIGO_GRUPO = ordem_servico_custo.CODIGO_GRUPO) DESCRICAO');
  sql.Add(', (SELECT grupo.SUB_DESCRICAO FROM grupo WHERE grupo.CODIGO_GRUPO = ordem_servico_custo.CODIGO_GRUPO) SUB_DESCRICAO');
  sql.Add('  FROM ordem_servico_custo');
  sql.Add(' WHERE ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_custo.`STATUS` = ''A'') X');
  sql.Add(' GROUP BY x.DESCRICAO ) Y');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add('');
  sql.Add('SELECT '''' DESCRICAO, '''' SUB_DESCRICAO, NULL QTDE, NULL VALOR_FINAL');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add('');
  sql.Add('SELECT X.NOME_FUNCAO DESCRICAO');
  sql.Add(', GROUP_CONCAT(DISTINCT X.NOME_FUNCIONARIO) SUB_DESCRICAO');
  sql.Add(', COUNT(X.NOME_FUNCAO) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(X.VALOR_TOTAL),0),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT IFNULL(');
  sql.Add('	    (ordem_servico_funcionario.VALOR_HORA_NORMAL * ordem_servico_funcionario.QTDE_HORAS_NORMAL) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 50) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_50) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 100) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_100) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 20) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_AD_NOTURNO)');
  sql.Add('	    ,0) VALOR_TOTAL');
  sql.Add(', (SELECT funcao.DESCRICAO FROM funcao WHERE funcao.CODIGO_FUNCAO = ordem_servico_funcionario.CODIGO_FUNCAO) NOME_FUNCAO ');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL FROM pessoa WHERE pessoa.CODIGO_PESSOA = ordem_servico_funcionario.CODIGO_PESSOA) NOME_FUNCIONARIO');
  sql.Add('  FROM ordem_servico_funcionario');
  sql.Add(' WHERE ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_funcionario.`STATUS` = ''A'') X');
  sql.Add(' GROUP BY X.NOME_FUNCAO');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add('');
  sql.Add('SELECT ''Total Custo Funcionario'' DESCRICAO, '''' SUB_DESCRICAO');
  sql.Add(', COUNT(Y.QTDE) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(Y.VALOR_FINAL),0),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT X.NOME_FUNCAO DESCRICAO');
  sql.Add(', GROUP_CONCAT(DISTINCT X.NOME_FUNCIONARIO) SUB_DESCRICAO');
  sql.Add(', COUNT(X.NOME_FUNCAO) QTDE');
  sql.Add(', IFNULL(IFNULL(SUM(X.VALOR_TOTAL),0),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT IFNULL(');
  sql.Add('	    (ordem_servico_funcionario.VALOR_HORA_NORMAL * ordem_servico_funcionario.QTDE_HORAS_NORMAL) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 50) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_50) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 100) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_100) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 20) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_AD_NOTURNO)');
  sql.Add('	    ,0) VALOR_TOTAL');
  sql.Add(', (SELECT funcao.DESCRICAO FROM funcao WHERE funcao.CODIGO_FUNCAO = ordem_servico_funcionario.CODIGO_FUNCAO) NOME_FUNCAO');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL FROM pessoa WHERE pessoa.CODIGO_PESSOA = ordem_servico_funcionario.CODIGO_PESSOA) NOME_FUNCIONARIO');
  sql.Add('  FROM ordem_servico_funcionario');
  sql.Add(' WHERE ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_funcionario.`STATUS` = ''A'') X');
  sql.Add(' GROUP BY X.NOME_FUNCAO) Y');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add('');
  sql.Add('SELECT '''' DESCRICAO, '''' SUB_DESCRICAO, NULL QTDE, NULL VALOR_FINAL');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add(' ');
  sql.Add('SELECT ''Total Custos'' DESCRICAO, '''' SUB_DESCRICAO ');
  sql.Add(', COUNT(X.VALOR_FINAL) QTDE, IFNULL(SUM(IFNULL(X.VALOR_FINAL,0)),0) VALOR_FINAL');
  sql.Add('  FROM (');
  sql.Add('SELECT IFNULL(SUM(IFNULL(ordem_servico_custo.QTDE * ordem_servico_custo.VALOR_UNITARIO,0)),0) VALOR_FINAL');
  sql.Add('  FROM ordem_servico_custo');
  sql.Add(' WHERE ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_custo.`STATUS` = ''A'' ');
  sql.Add('');
  sql.Add('UNION ALL');
  sql.Add('');
  sql.Add('SELECT IFNULL(SUM(IFNULL(');
  sql.Add('	    (ordem_servico_funcionario.VALOR_HORA_NORMAL * ordem_servico_funcionario.QTDE_HORAS_NORMAL) + ');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 50) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_50) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 100) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_100) +');
  sql.Add('	    ((((ordem_servico_funcionario.VALOR_HORA_NORMAL / 100) * 20) +ordem_servico_funcionario.VALOR_HORA_NORMAL) * ordem_servico_funcionario.QTDE_HORA_AD_NOTURNO)');
  sql.Add('	    ,0)),0) VALOR_TOTAL');
  sql.Add('  FROM ordem_servico_funcionario');
  sql.Add('WHERE ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_funcionario.`STATUS` = ''A'') X');

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
    SetLength(custos, query.RecordCount);
    contador := 0;

    while not query.Eof do
    begin
      try
        data := TCusto.Create;

        data.FGrupo.descricao := query.FieldByName('DESCRICAO').AsString;
        data.FGrupo.subDescricao := query.FieldByName('SUB_DESCRICAO').AsString;
        data.FQuantidade := query.FieldByName('QTDE').AsFloat;
        data.FValorUnitario := query.FieldByName('VALOR_FINAL').AsFloat;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao montar Custo agrupado ' + e.Message);
          data := nil;
        end;
      end;

      custos[contador] := data;
      query.Next;
      inc(contador);
    end;

    Result := custos;
  end;

  FreeAndNil(sql);
end;

function TCusto.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(CODIGO_CUSTO) TOTAL');
  sql.Add('  FROM ordem_servico_custo, grupo');
  sql.Add(' WHERE ordem_servico_custo.`STATUS` = ' + QuotedStr(FStatus));
  sql.Add('   AND ordem_servico_custo.CODIGO_GRUPO = grupo.CODIGO_GRUPO');

  if (FOrdemServico.id > 0) then
  begin
    sql.Add('   AND ordem_servico_custo.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND ordem_servico_custo.CODIGO_CUSTO = ' + IntToStrSenaoZero(FCodigo));
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

constructor TCusto.Create;
begin
  FOrdemServico := TOrdemServico.Create;
  FGrupo := TGrupo.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

end.
