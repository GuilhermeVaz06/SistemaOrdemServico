unit Model.OrdemServico.Item;

interface

uses Model.Sessao, System.SysUtils, Model.OrdemServico, ZDataset, System.Classes;

type TItem = class

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
    function montarItem(query: TZQuery): TItem;
    function consultarCodigo(codigo: integer): TItem;

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

    function consultar: TArray<TItem>;
    function consultarChave: TItem;
    function existeRegistro: TItem;
    function cadastrarItem: TItem;
    function alterarItem: TItem;
    function inativarItem: TItem;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TItem }

destructor TItem.Destroy;
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

function TItem.existeRegistro: TItem;
var
  query: TZQuery;
  itemConsultado: TItem;
  sql: TStringList;
begin
  itemConsultado := TItem.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ITEM, DESCRICAO, `STATUS`');
  sql.Add('  FROM ordem_servico_item');
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_ITEM <> ' + IntToStrSenaoZero(FCodigo));
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

    itemConsultado.FCodigo := query.FieldByName('CODIGO_ITEM').Value;
    itemConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    itemConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := itemConsultado;

  FreeAndNil(sql);
end;

function TItem.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TItem.inativarItem: TItem;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_item`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ITEM = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TItem.limpar;
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

function TItem.montarItem(query: TZQuery): TItem;
var
  data: TItem;
begin
  try
    data := TItem.Create;

    data.FOrdemServico.id := query.FieldByName('CODIGO_OS').Value;
    data.FCodigo := query.FieldByName('CODIGO_ITEM').Value;
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
      raise Exception.Create('Erro ao montar Item ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TItem.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TItem.alterarItem: TItem;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico_item` ');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , QTDE = ' + VirgulaPonto(FQuantidade));
  sql.Add('     , VALOR_UNITARIO = ' + VirgulaPonto(FValorUnitario));
  sql.Add('     , DESCONTO = ' + VirgulaPonto(FDesconto));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  sql.Add('   AND CODIGO_ITEM = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TItem.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TItem.cadastrarItem: TItem;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico_item', 'CODIGO_ITEM');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico_item` (CODIGO_OS, CODIGO_ITEM, DESCRICAO, QTDE');
  sql.Add(', VALOR_UNITARIO, DESCONTO, CODIGO_SESSAO_CADASTRO, CODIGO_SESSAO_ALTERACAO) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FOrdemServico.id));                           //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_ITEM
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

function TItem.calculaValorDesconto: Double;
begin
  Result := (calculaValorTotal / 100) * FDesconto;
end;

function TItem.calculaValorFinal: Double;
begin
  Result := calculaValorTotal - calculaValorDesconto;
end;

function TItem.calculaValorTotal: Double;
begin
  Result := FValorUnitario * FQuantidade;
end;

function TItem.consultar: TArray<TItem>;
var
  query: TZQuery;
  contatos: TArray<TItem>;
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
    sql.Add('SELECT ordem_servico_item.CODIGO_OS, ordem_servico_item.CODIGO_ITEM, ordem_servico_item.DESCRICAO');
    sql.Add(', ordem_servico_item.QTDE, ordem_servico_item.VALOR_UNITARIO, ordem_servico_item.DESCONTO');
    sql.Add(', ordem_servico_item.CODIGO_SESSAO_CADASTRO, ordem_servico_item.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', ordem_servico_item.DATA_CADASTRO, ordem_servico_item.DATA_ULTIMA_ALTERACAO, ordem_servico_item.`STATUS`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_item.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_item.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM ordem_servico_item');
    sql.Add(' WHERE ordem_servico_item.`STATUS` = ' + QuotedStr(FStatus));

    if (FOrdemServico.id > 0) then
    begin
      sql.Add('   AND ordem_servico_item.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND ordem_servico_item.CODIGO_ITEM = ' + IntToStrSenaoZero(FCodigo));
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
        contatos[contador] := montarItem(query);
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

function TItem.consultarChave: TItem;
var
  query: TZQuery;
  itemConsultado: TItem;
  sql: TStringList;
begin
  itemConsultado := TItem.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ITEM, DESCRICAO');
  sql.Add('  FROM ordem_servico_item');
  sql.Add(' WHERE CODIGO_ITEM = ' + IntToStrSenaoZero(FCodigo));
  sql.Add('   AND CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
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

    itemConsultado.FCodigo := query.FieldByName('CODIGO_ITEM').Value;
    itemConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := itemConsultado;

  FreeAndNil(sql);
end;

function TItem.consultarCodigo(codigo: integer): TItem;
var
  query: TZQuery;
  sql: TStringList;
  itemConsultado: TItem;
begin
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico_item.CODIGO_OS, ordem_servico_item.CODIGO_ITEM, ordem_servico_item.DESCRICAO');
  sql.Add(', ordem_servico_item.QTDE, ordem_servico_item.VALOR_UNITARIO, ordem_servico_item.DESCONTO');
  sql.Add(', ordem_servico_item.CODIGO_SESSAO_CADASTRO, ordem_servico_item.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', ordem_servico_item.DATA_CADASTRO, ordem_servico_item.DATA_ULTIMA_ALTERACAO, ordem_servico_item.`STATUS`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL ');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_item.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico_item.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM ordem_servico_item');
  sql.Add(' WHERE ordem_servico_item.CODIGO_ITEM = ' + IntToStrSenaoZero(codigo));

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
    itemConsultado := montarItem(query);
  end;

  Result := itemConsultado;
  FreeAndNil(sql);
end;

function TItem.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(CODIGO_ITEM) TOTAL');
  sql.Add('  FROM ordem_servico_item');
    sql.Add(' WHERE ordem_servico_item.`STATUS` = ' + QuotedStr(FStatus));

  if (FOrdemServico.id > 0) then
  begin
    sql.Add('   AND ordem_servico_item.CODIGO_OS = ' + IntToStrSenaoZero(FOrdemServico.id));
  end;

  if (FCodigo > 0) then
  begin
    sql.Add('   AND ordem_servico_item.CODIGO_ITEM = ' + IntToStrSenaoZero(FCodigo));
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

constructor TItem.Create;
begin
  FOrdemServico := TOrdemServico.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

end.
