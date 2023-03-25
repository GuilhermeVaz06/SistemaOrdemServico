unit Model.OrdemServico.Funcionario;

interface

uses Model.Sessao, System.SysUtils, Model.OrdemServico, Model.Funcao, ZDataset,
     Model.Pessoa, System.Classes;

type TFuncionario = class

  private
    FCodigo: integer;
    FOrdemServico: TOrdemServico;
    FFuncao: TFuncao;
    FFuncionario: TPessoa;
    FQtdeHoraNormal: Integer;
    FQtdeHora50: Integer;
    FQtdeHora100: Integer;
    FQtdeHoraAdNoturno: Integer;
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

    function calculaValorTotal: Double;
    function calculaValorHora50: Double;
    function calculaValorHora100: Double;
    function calculaValorHoraAdNoturno: Double;
    function calculaValorTotalNormal: Double;
    function calculaValorTotal50: Double;
    function calculaValorTotal100: Double;
    function calculaValorTotalAdNoturno: Double;
    function contar: integer;
    function montarFuncionario(query: TZQuery): TFuncionario;
    function consultarCodigo(codigo: integer): TFuncionario;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property ordemServico: TOrdemServico read FOrdemServico write FOrdemServico;
    property funcao: TFuncao read FFuncao write FFuncao;
    property funcionario: TPessoa read FFuncionario write FFuncionario;
    property qtdeHoraNormal: Integer read FQtdeHoraNormal write FQtdeHoraNormal;
    property qtdeHora50: Integer read FQtdeHora50 write FQtdeHora50;
    property qtdeHora100: Integer read FQtdeHora100 write FQtdeHora100;
    property qtdeHoraAdNoturno: Integer read FQtdeHoraAdNoturno write FQtdeHoraAdNoturno;
    property valorHoraNormal: Double read FValorHoraNormal write FValorHoraNormal;
    property valorHora50: Double read calculaValorHora50;
    property valorHora100: Double read calculaValorHora100;
    property valorHoraAdNoturno: Double read calculaValorHoraAdNoturno;
    property valorTotalNormal: Double read calculaValorTotalNormal;
    property valorTotal50: Double read calculaValorTotal50;
    property valorTotal100: Double read calculaValorTotal100;
    property valorTotalAdNoturno: Double read calculaValorTotalAdNoturno;
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

    function consultar: TArray<TFuncionario>;
    function consultarChave: TFuncionario;
    function existeRegistro: TFuncionario;
    function cadastrarFuncionario: TFuncionario;
    function alterarFuncionario: TFuncionario;
    function inativarFuncionario: TFuncionario;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TFuncionario }

destructor TFuncionario.Destroy;
begin
  if Assigned(FOrdemServico) then
  begin
    FOrdemServico.Destroy;
  end;

  if Assigned(FFuncao) then
  begin
    FFuncao.Destroy;
  end;

  if Assigned(FFuncionario) then
  begin
    FFuncionario.Destroy;
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

function TFuncionario.existeRegistro: TFuncionario;
var
  query: TZQuery;
  itemConsultado: TFuncionario;
  sql: TStringList;
begin
  itemConsultado := TFuncionario.Create;
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_funcionario.CODIGO_FUNCIONARIO, funcao.DESCRICAO');
  sql.Add('');
  sql.Add(',(SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('    FROM pessoa ');
  sql.Add('   WHERE pessoa.CODIGO_PESSOA  = ordem_servico_funcionario.CODIGO_PESSOA) nomeFuncionario');
  sql.Add('');
  sql.Add(', ordem_servico_funcionario.`STATUS`');
  sql.Add('  FROM ordem_servico_funcionario, funcao');
  sql.Add(' WHERE ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = ' + IntToStrSenaoZero(FFuncao.id));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_PESSOA = ' + IntToStrSenaoZero(FFuncionario.id));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = funcao.CODIGO_FUNCAO');

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_FUNCIONARIO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    itemConsultado.Destroy;
    itemConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    itemConsultado.FCodigo := query.FieldByName('CODIGO_FUNCIONARIO').Value;
    itemConsultado.FFuncao.descricao := query.FieldByName('DESCRICAO').Value;
    itemConsultado.FFuncionario.razaoSocial := query.FieldByName('nomeFuncionario').Value;
    itemConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := itemConsultado;

  FreeAndNil(sql);
end;

function TFuncionario.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TFuncionario.inativarFuncionario: TFuncionario;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_funcionario`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TFuncionario.limpar;
begin
  FCodigo := 0;
  FOrdemServico.limpar;
  FFuncao.limpar;
  FFuncionario.limpar;
  FQtdeHoraNormal := 0;
  FQtdeHora50 := 0;
  FQtdeHora100 := 0;
  FQtdeHoraAdNoturno := 0;
  FValorHoraNormal := 0;
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

function TFuncionario.montarFuncionario(query: TZQuery): TFuncionario;
var
  data: TFuncionario;
begin
  try
    data := TFuncionario.Create;

    data.FOrdemServico.id := query.FieldByName('CODIGO_OS').Value;
    data.FCodigo := query.FieldByName('CODIGO_FUNCIONARIO').Value;
    data.FFuncao.id := query.FieldByName('CODIGO_FUNCAO').Value;
    data.FFuncao.descricao := query.FieldByName('DESCRICAO').Value;
    data.FFuncionario.id := query.FieldByName('CODIGO_PESSOA').Value;
    data.FFuncionario.razaoSocial := query.FieldByName('nomeFuncionario').Value;
    data.FQtdeHoraNormal := query.FieldByName('QTDE_HORAS_NORMAL').Value;
    data.FQtdeHora50 := query.FieldByName('QTDE_HORA_50').Value;
    data.FQtdeHora100 := query.FieldByName('QTDE_HORA_100').Value;
    data.FQtdeHoraAdNoturno := query.FieldByName('QTDE_HORA_AD_NOTURNO').Value;
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
      raise Exception.Create('Erro ao montar Funcionario ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TFuncionario.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TFuncionario.alterarFuncionario: TFuncionario;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_funcionario` ');
  sql.Add('   SET CODIGO_FUNCAO = ' + IntToStrSenaoZero(FFuncao.id));
  sql.Add('     , CODIGO_PESSOA = ' + IntToStrSenaoZero(FFuncionario.id));
  sql.Add('     , QTDE_HORAS_NORMAL = ' + IntToStrSenaoZero(FQtdeHoraNormal));
  sql.Add('     , QTDE_HORA_50 = ' + IntToStrSenaoZero(FQtdeHora50));
  sql.Add('     , QTDE_HORA_100 = ' + IntToStrSenaoZero(FQtdeHora100));
  sql.Add('     , QTDE_HORA_AD_NOTURNO = ' + IntToStrSenaoZero(FQtdeHoraAdNoturno));
  sql.Add('     , VALOR_HORA_NORMAL = ' + VirgulaPonto(FValorHoraNormal));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TFuncionario.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TFuncionario.cadastrarFuncionario: TFuncionario;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico_funcionario', 'CODIGO_FUNCIONARIO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico_funcionario` (CODIGO_OS, CODIGO_FUNCIONARIO, CODIGO_FUNCAO, CODIGO_PESSOA');
  sql.Add(', QTDE_HORAS_NORMAL, QTDE_HORA_50, QTDE_HORA_100, QTDE_HORA_AD_NOTURNO, VALOR_HORA_NORMAL');
  sql.Add(', CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FOrdemServico.id));                           //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_FUNCIONARIO
  sql.Add(',' + IntToStrSenaoZero(FFuncao.id));                                 //CODIGO_FUNCAO
  sql.Add(',' + IntToStrSenaoZero(FFuncionario.id));                            //CODIGO_PESSOA
  sql.Add(',' + VirgulaPonto(FQtdeHoraNormal));                                 //QTDE_HORAS_NORMAL
  sql.Add(',' + VirgulaPonto(FQtdeHora50));                                     //QTDE_HORA_50
  sql.Add(',' + VirgulaPonto(FQtdeHora100));                                    //QTDE_HORA_100
  sql.Add(',' + VirgulaPonto(FQtdeHoraAdNoturno));                              //QTDE_HORA_AD_NOTURNO
  sql.Add(',' + VirgulaPonto(FValorHoraNormal));                                //VALOR_HORA_NORMAL
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TFuncionario.calculaValorHora100: Double;
begin
  Result := ((FValorHoraNormal / 100) * 100) + FValorHoraNormal;
end;

function TFuncionario.calculaValorHora50: Double;
begin
  Result := ((FValorHoraNormal / 100) * 50) + FValorHoraNormal;
end;

function TFuncionario.calculaValorHoraAdNoturno: Double;
begin
  Result := ((FValorHoraNormal / 100) * 20) + FValorHoraNormal;
end;

function TFuncionario.calculaValorTotal: Double;
begin
  Result := calculaValorTotalNormal +
            calculaValorTotal50 +
            calculaValorTotal100 +
            calculaValorTotalAdNoturno;
end;

function TFuncionario.calculaValorTotal100: Double;
begin
  Result := calculaValorHora100 * FQtdeHora100;
end;

function TFuncionario.calculaValorTotal50: Double;
begin
  Result := calculaValorHora50 * FQtdeHora50;
end;

function TFuncionario.calculaValorTotalAdNoturno: Double;
begin
  Result := calculaValorHoraAdNoturno * FQtdeHoraAdNoturno;
end;

function TFuncionario.calculaValorTotalNormal: Double;
begin
    Result := FValorHoraNormal * FQtdeHoraNormal;
end;

function TFuncionario.consultar: TArray<TFuncionario>;
var
  query: TZQuery;
  contatos: TArray<TFuncionario>;
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
    sql.Add('SELECT ordem_servico_funcionario.CODIGO_OS, ordem_servico_funcionario.CODIGO_FUNCIONARIO, funcao.DESCRICAO');
    sql.Add(', ordem_servico_funcionario.CODIGO_PESSOA, ordem_servico_funcionario.VALOR_HORA_NORMAL');
    sql.Add(', ordem_servico_funcionario.QTDE_HORAS_NORMAL, ordem_servico_funcionario.QTDE_HORA_50');
    sql.Add(', ordem_servico_funcionario.QTDE_HORA_100, ordem_servico_funcionario.QTDE_HORA_AD_NOTURNO');
    sql.Add(', ordem_servico_funcionario.CODIGO_SESSAO_CADASTRO, ordem_servico_funcionario.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', ordem_servico_funcionario.DATA_CADASTRO, ordem_servico_funcionario.DATA_ULTIMA_ALTERACAO');
    sql.Add(', ordem_servico_funcionario.`STATUS`, ordem_servico_funcionario.`CODIGO_FUNCAO`');
    sql.Add('');
    sql.Add(',(SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('    FROM pessoa ');
    sql.Add('   WHERE pessoa.CODIGO_PESSOA  = ordem_servico_funcionario.CODIGO_PESSOA) nomeFuncionario');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_funcionario.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_funcionario.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM ordem_servico_funcionario, funcao');
    sql.Add(' WHERE ordem_servico_funcionario.`STATUS` = ' + QuotedStr(FStatus));
    sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = funcao.CODIGO_FUNCAO');

    if (FOrdemServico.id > 0) then
    begin
      sql.Add('   AND ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(FCodigo));
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
      SetLength(contatos, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        contatos[contador] := montarFuncionario(query);
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

function TFuncionario.consultarChave: TFuncionario;
var
  query: TZQuery;
  itemConsultado: TFuncionario;
  sql: TStringList;
begin
  itemConsultado := TFuncionario.Create;
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_funcionario.CODIGO_FUNCIONARIO, funcao.DESCRICAO');
  sql.Add('  FROM ordem_servico_funcionario, funcao');
  sql.Add(' WHERE CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND CODIGO_PESSOA = ' + IntToStrSenaoZero(FFuncionario.id));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = funcao.CODIGO_FUNCAO');
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    itemConsultado.Destroy;
    itemConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    itemConsultado.FCodigo := query.FieldByName('CODIGO_FUNCIONARIO').Value;
    itemConsultado.FFuncao.descricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := itemConsultado;

  FreeAndNil(sql);
end;

function TFuncionario.consultarCodigo(codigo: integer): TFuncionario;
var
  query: TZQuery;
  sql: TStringList;
  itemConsultado: TFuncionario;
begin
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_funcionario.CODIGO_OS, ordem_servico_funcionario.CODIGO_FUNCIONARIO, funcao.DESCRICAO');
  sql.Add(', ordem_servico_funcionario.CODIGO_PESSOA, ordem_servico_funcionario.VALOR_HORA_NORMAL');
  sql.Add(', ordem_servico_funcionario.QTDE_HORAS_NORMAL, ordem_servico_funcionario.QTDE_HORA_50');
  sql.Add(', ordem_servico_funcionario.QTDE_HORA_100, ordem_servico_funcionario.QTDE_HORA_AD_NOTURNO');
  sql.Add(', ordem_servico_funcionario.CODIGO_SESSAO_CADASTRO, ordem_servico_funcionario.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', ordem_servico_funcionario.DATA_CADASTRO, ordem_servico_funcionario.DATA_ULTIMA_ALTERACAO');
  sql.Add(', ordem_servico_funcionario.`STATUS`, ordem_servico_funcionario.`CODIGO_FUNCAO`');
  sql.Add('');
  sql.Add(',(SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('    FROM pessoa ');
  sql.Add('   WHERE pessoa.CODIGO_PESSOA  = ordem_servico_funcionario.CODIGO_PESSOA) nomeFuncionario');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_funcionario.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_funcionario.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM ordem_servico_funcionario, funcao');
  sql.Add(' WHERE ordem_servico_funcionario.CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(codigo));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = funcao.CODIGO_FUNCAO');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    itemConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    itemConsultado := montarFuncionario(query);
  end;

  Result := itemConsultado;
  FreeAndNil(sql);
end;

function TFuncionario.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(CODIGO_FUNCIONARIO) TOTAL');
  sql.Add('  FROM ordem_servico_funcionario, funcao');
  sql.Add(' WHERE ordem_servico_funcionario.`STATUS` = ' + QuotedStr(FStatus));
  sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCAO = funcao.CODIGO_FUNCAO');

  if (FOrdemServico.id > 0) then
  begin
    sql.Add('   AND ordem_servico_funcionario.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND ordem_servico_funcionario.CODIGO_FUNCIONARIO = ' + IntToStrSenaoZero(FCodigo));
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

constructor TFuncionario.Create;
begin
  FOrdemServico := TOrdemServico.Create;
  FFuncao := TFuncao.Create;
  FFuncionario := TPessoa.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

end.
