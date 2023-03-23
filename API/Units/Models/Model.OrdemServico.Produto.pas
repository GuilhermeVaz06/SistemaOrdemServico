unit Model.OrdemServico.Produto;

interface

uses Model.Sessao, System.SysUtils, Model.OrdemServico, ZDataset, System.Classes;

type TProduto = class

  private
    FCodigo: integer;
    FOrdemServico: TOrdemServico;
    FDescricao: string;
    FQuantidade: Double;
    FValorUnitario: Double;
    FDesconto: Double;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

    function calculaValorDesconto: Double;
    function calculaValorFinal: Double;
    function calculaValorTotal: Double;
    function contar: integer;
    function consultarCodigo(codigo: integer): TProduto;
    function montarProduto(query: TZQuery): TProduto;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;

    property ordemServico: TOrdemServico read FOrdemServico write FOrdemServico;
    property descricao: string read FDescricao write FDescricao;
    property quantidade: Double read FQuantidade write FQuantidade;
    property valorUnitario: Double read FValorUnitario write FValorUnitario;
    property valorTotal: Double read calculaValorTotal;
    property desconto: Double read FDesconto write FDesconto;
    property valorDesconto: Double read calculaValorDesconto;
    property valorFinal: Double read calculaValorFinal;

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

    function consultar: TArray<TProduto>;
    function consultarChave: TProduto;
    function existeRegistro: TProduto;
    function cadastrarProduto: TProduto;
    function alterarProduto: TProduto;
    function inativarProduto: TProduto;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TProduto }

destructor TProduto.Destroy;
begin
  if Assigned(FOrdemServico) then
  begin
    FOrdemServico.Destroy;
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

function TProduto.existeRegistro: TProduto;
var
  query: TZQuery;
  produtoConsultado: TProduto;
  sql: TStringList;
begin
  produtoConsultado := TProduto.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PRODUTO, DESCRICAO, `STATUS`');
  sql.Add('  FROM ordem_servico_produto');
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_PRODUTO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    produtoConsultado.Destroy;
    produtoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    produtoConsultado.FCodigo := query.FieldByName('CODIGO_PRODUTO').Value;
    produtoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    produtoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := produtoConsultado;

  FreeAndNil(sql);
end;

function TProduto.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TProduto.inativarProduto: TProduto;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_produto`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_PRODUTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TProduto.limpar;
begin
  FCodigo := 0;
  FOrdemServico.limpar;
  FDescricao := '';
  FQuantidade := 0;
  FValorUnitario := 0;
  FDesconto := 0;
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

function TProduto.montarProduto(query: TZQuery): TProduto;
var
  data: TProduto;
begin
  try
    data := TProduto.Create;

    data.FOrdemServico.id := query.FieldByName('CODIGO_OS').Value;
    data.FCodigo := query.FieldByName('CODIGO_PRODUTO').Value;
    data.FDescricao := query.FieldByName('DESCRICAO').Value;
    data.FQuantidade := query.FieldByName('QTDE').Value;
    data.FValorUnitario := query.FieldByName('VALOR_UNITARIO').Value;
    data.FDesconto := query.FieldByName('DESCONTO').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Produto ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TProduto.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TProduto.alterarProduto: TProduto;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_produto` ');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , QTDE = ' + VirgulaPonto(FQuantidade));
  sql.Add('     , VALOR_UNITARIO = ' + VirgulaPonto(FValorUnitario));
  sql.Add('     , DESCONTO = ' + VirgulaPonto(FDesconto));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND CODIGO_PRODUTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TProduto.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TProduto.cadastrarProduto: TProduto;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico_produto', 'CODIGO_PRODUTO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico_produto` (CODIGO_OS, CODIGO_PRODUTO, DESCRICAO, QTDE');
  sql.Add(', VALOR_UNITARIO, DESCONTO, CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FOrdemServico.id));                           //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_PRODUTO
  sql.Add(',' + QuotedStr(FDescricao));                                         //DESCRICAO
  sql.Add(',' + VirgulaPonto(FQuantidade));                                     //QTDE
  sql.Add(',' + VirgulaPonto(FValorUnitario));                                  //VALOR_UNITARIO
  sql.Add(',' + VirgulaPonto(FDesconto));                                       //DESCONTO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TProduto.calculaValorDesconto: Double;
begin
  Result := (calculaValorTotal / 100) * FDesconto;
end;

function TProduto.calculaValorFinal: Double;
begin
  Result := calculaValorTotal - calculaValorDesconto;
end;

function TProduto.calculaValorTotal: Double;
begin
  Result := FValorUnitario * FQuantidade;
end;

function TProduto.consultar: TArray<TProduto>;
var
  query: TZQuery;
  contatos: TArray<TProduto>;
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
    sql.Add('SELECT ordem_servico_produto.CODIGO_OS, ordem_servico_produto.CODIGO_PRODUTO, ordem_servico_produto.DESCRICAO');
    sql.Add(', ordem_servico_produto.QTDE, ordem_servico_produto.VALOR_UNITARIO, ordem_servico_produto.DESCONTO');
    sql.Add(', ordem_servico_produto.CODIGO_SESSAO_CADASTRO, ordem_servico_produto.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', ordem_servico_produto.DATA_CADASTRO, ordem_servico_produto.DATA_ULTIMA_ALTERACAO, ordem_servico_produto.`STATUS`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_produto.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_produto.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM ordem_servico_produto');
    sql.Add(' WHERE ordem_servico_produto.`STATUS` = ' + QuotedStr(FStatus));

    if (FOrdemServico.id > 0) then
    begin
      sql.Add('   AND ordem_servico_produto.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND ordem_servico_produto.CODIGO_PRODUTO = ' + IntToStrSenaoZero(FCodigo));
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
        contatos[contador] := montarProduto(query);
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

function TProduto.consultarChave: TProduto;
var
  query: TZQuery;
  produtoConsultado: TProduto;
  sql: TStringList;
begin
  produtoConsultado := TProduto.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PRODUTO, DESCRICAO');
  sql.Add('  FROM ordem_servico_produto');
  sql.Add(' WHERE CODIGO_PRODUTO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    produtoConsultado.Destroy;
    produtoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    produtoConsultado.FCodigo := query.FieldByName('CODIGO_PRODUTO').Value;
    produtoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := produtoConsultado;

  FreeAndNil(sql);
end;

function TProduto.consultarCodigo(codigo: integer): TProduto;
var
  query: TZQuery;
  sql: TStringList;
  produtoConsultado: TProduto;
begin
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_produto.CODIGO_OS, ordem_servico_produto.CODIGO_PRODUTO, ordem_servico_produto.DESCRICAO');
  sql.Add(', ordem_servico_produto.QTDE, ordem_servico_produto.VALOR_UNITARIO, ordem_servico_produto.DESCONTO');
  sql.Add(', ordem_servico_produto.CODIGO_SESSAO_CADASTRO, ordem_servico_produto.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', ordem_servico_produto.DATA_CADASTRO, ordem_servico_produto.DATA_ULTIMA_ALTERACAO, ordem_servico_produto.`STATUS`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_produto.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_produto.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM ordem_servico_produto');
  sql.Add(' WHERE ordem_servico_produto.CODIGO_PRODUTO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    produtoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    produtoConsultado := montarProduto(query);
  end;

  Result := produtoConsultado;
  FreeAndNil(sql);
end;

function TProduto.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(CODIGO_PRODUTO) TOTAL');
  sql.Add('  FROM ordem_servico_produto');
    sql.Add(' WHERE ordem_servico_produto.`STATUS` = ' + QuotedStr(FStatus));

  if (FOrdemServico.id > 0) then
  begin
    sql.Add('   AND ordem_servico_produto.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND ordem_servico_produto.CODIGO_PRODUTO = ' + IntToStrSenaoZero(FCodigo));
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

constructor TProduto.Create;
begin
  FOrdemServico := TOrdemServico.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

end.
