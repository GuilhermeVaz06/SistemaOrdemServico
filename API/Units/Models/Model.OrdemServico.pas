unit Model.OrdemServico;

interface

uses system.SysUtils, Model.Sessao, Model.Pessoa.Endereco, Model.Pessoa,
      ZDataset, System.Classes;

type TOrdemServico = class

  private
    FCodigo: integer;
    FEmpresa: TPessoa;
    FCLiente: TPessoa;
    FEndereco: TEndereco;
    FTransportador: Tpessoa;
    FFinalidade: string;
    FTipoFrete: string;
    FDetalhamento: string;
    FObservacao: string;
    FDataEntrega: TDate;
    FDataOrdem: Tdate;
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

    function contar: integer;
    function montarOrdemServico(query: TZQuery): TOrdemServico;
    function consultarCodigo(codigo: integer): TOrdemServico;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property empresa: TPessoa read FEmpresa write FEmpresa;
    property cliente: TPessoa read FCLiente write FCLiente;
    property endereco: TEndereco read FEndereco write FEndereco;
    property transportador: Tpessoa read FTransportador write FTransportador;
    property finalidade: string read FFinalidade write FFinalidade;
    property tipoFrete: string read FTipoFrete write FTipoFrete;
    property detalhamento: string read FDetalhamento write FDetalhamento;
    property observacao: string read FObservacao write FObservacao;
    property dataEntrega: TDate read FDataEntrega write FDataEntrega;
    property dataOrdem: TDate read FDataOrdem write FDataOrdem;
    property desconto: Double read FDesconto write FDesconto;
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

    function consultar: TArray<TOrdemServico>;
    function consultarChave: TOrdemServico;
    function existeRegistro: TOrdemServico;
    function cadastrarOrdemServico: TOrdemServico;
    function alterarOrdemServico: TOrdemServico;
    function inativarOrdemServico: TOrdemServico;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses UFuncao, Principal;

{ TOrdemServico }

function TOrdemServico.alterarOrdemServico: TOrdemServico;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico`');
  sql.Add('   SET CODIGO_EMPRESA = ' + IntToStrSenaoZero(FEmpresa.id));
  sql.Add('     , `CODIGO_CLIENTE` = ' + IntToStrSenaoZero(FCLiente.id));
  sql.Add('     , `CODIGO_ENDERECO` = ' + IntToStrSenaoZero(FEndereco.id));
  sql.Add('     , `CODIGO_TRANSPORTADORA` = ' + IntToStrSenaoZero(FTransportador.id));
  sql.Add('     , `FINALIDADE` = ' + QuotedStr(FFinalidade));
  sql.Add('     , `TIPO_FRETE` = ' + QuotedStr(FTipoFrete));
  sql.Add('     , `DETALHAMENTO` = ' + QuotedStr(FDetalhamento));
  sql.Add('     , `OBSERVACAO` = ' + QuotedStr(FObservacao));
  sql.Add('     , `DATA_PRAZO_ENTREGA` = ' + DataBD(FDataEntrega));
  sql.Add('     , `DATA_OS` = ' + DataBD(FDataOrdem));
  sql.Add('     , `DESCONTO` = ' + VirgulaPonto(FDesconto));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TOrdemServico.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TOrdemServico.cadastrarOrdemServico: TOrdemServico;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico', 'CODIGO_OS');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico` (`CODIGO_OS`, `CODIGO_EMPRESA`, `CODIGO_CLIENTE`, `CODIGO_ENDERECO`');
  sql.Add(', `CODIGO_TRANSPORTADORA`, `FINALIDADE`, `TIPO_FRETE`, `DETALHAMENTO`, `OBSERVACAO`');
  sql.Add(', `DATA_PRAZO_ENTREGA`, `DATA_OS`');
  sql.Add(', `DESCONTO`, `CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(FEmpresa.id));                                //CODIGO_EMPRESA
  sql.Add(',' + IntToStrSenaoZero(Fcliente.id));                                //CODIGO_CLIENTE
  sql.Add(',' + IntToStrSenaoZero(FEndereco.id));                               //CODIGO_ENDERECO
  sql.Add(',' + IntToStrSenaoZero(FTransportador.id));                          //CODIGO_TRANSPORTADORA
  sql.Add(',' + QuotedStr(FFinalidade));                                        //FINALIDADE
  sql.Add(',' + QuotedStr(FTipoFrete));                                         //TIPO_FRETE
  sql.Add(',' + QuotedStr(FDetalhamento));                                      //DETALHAMENTO
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + DataBD(FDataEntrega));                                          //DATA_PRAZO_ENTREGA
  sql.Add(',' + DataBD(FDataOrdem));                                            //DATA_OS
  sql.Add(',' + VirgulaPonto(FDesconto));                                       //DESCONTO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TOrdemServico.consultar: TArray<TOrdemServico>;
var
  query: TZQuery;
  ordensServico: TArray<TOrdemServico>;
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
      SetLength(ordensServico, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        ordensServico[contador] := montarOrdemServico(query);
        query.Next;
        inc(contador);
      end;

      Result := ordensServico;
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

function TOrdemServico.consultarChave: TOrdemServico;
var
  query: TZQuery;
//  grupoConsultado: TOrdemServico;
  sql: TStringList;
begin
//  grupoConsultado := TOrdemServico.Create;
//  sql := TStringList.Create;
//  sql.Add('SELECT CODIGO_GRUPO, DESCRICAO');
//  sql.Add('  FROM grupo');
//  sql.Add(' WHERE CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
//  sql.Add(' LIMIT 1');
//
//  query := FConexao.executarComandoDQL(sql.Text);
//
//  if not Assigned(query)
//  or (query = nil)
//  or (query.RecordCount = 0) then
//  begin
//    grupoConsultado.Destroy;
//    grupoConsultado := nil;
//  end
//  else
//  begin
//    query.First;
//    FRegistrosAfetados := FConexao.registrosAfetados;
//
//    grupoConsultado.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
//    grupoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
//  end;
//
//  Result := grupoConsultado;
//
//  FreeAndNil(sql);
end;

function TOrdemServico.consultarCodigo(codigo: integer): TOrdemServico;
var
  query: TZQuery;
  sql: TStringList;
//  grupoConsultado: TOrdemServico;
begin
//  sql := TStringList.Create;
//  sql.Add('SELECT grupo.CODIGO_GRUPO, grupo.DESCRICAO, grupo.CODIGO_SESSAO_CADASTRO');
//  sql.Add(', grupo.CODIGO_SESSAO_ALTERACAO, grupo.DATA_CADASTRO, grupo.DATA_ULTIMA_ALTERACAO');
//  sql.Add(', grupo.`STATUS`');
//  sql.Add('');
//  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
//  sql.Add('     FROM pessoa, sessao ');
//  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
//  sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
//  sql.Add('');
//  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
//  sql.Add('     FROM pessoa, sessao ');
//  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
//  sql.Add('      AND sessao.CODIGO_SESSAO = grupo.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
//  sql.Add('');
//  sql.Add('  FROM grupo');
//  sql.Add(' WHERE grupo.CODIGO_GRUPO = ' + IntToStrSenaoZero(codigo));
//
//  query := FConexao.executarComandoDQL(sql.Text);
//
//  if not Assigned(query)
//  or (query = nil)
//  or (query.RecordCount = 0) then
//  begin
//    grupoConsultado := nil;
//  end
//  else
//  begin
//    query.First;
//    FRegistrosAfetados := FConexao.registrosAfetados;
//    grupoConsultado := montarGrupo(query);
//  end;
//
//  Result := grupoConsultado;
//  FreeAndNil(sql);
end;

function TOrdemServico.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
//  sql := TStringList.Create;
//  sql.Add('SELECT COUNT(grupo.CODIGO_GRUPO) TOTAL');
//  sql.Add('  FROM grupo');
//  sql.Add(' WHERE grupo.`STATUS` = ' + QuotedStr(FStatus));
//
//  if (FDescricao <> '') then
//  begin
//    sql.Add('   AND grupo.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
//  end;
//
//  if  (FCodigo > 0) then
//  begin
//    sql.Add('   AND grupo.CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
//  end;
//
//  query := FConexao.executarComandoDQL(sql.Text);
//
//  if not Assigned(query)
//  or (query = nil)
//  or (query.RecordCount = 0) then
//  begin
//    Result := 0;
//  end
//  else
//  begin
//    Result := query.FieldByName('TOTAL').Value;
//  end;

  FreeAndNil(sql);
end;

constructor TOrdemServico.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

destructor TOrdemServico.Destroy;
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

function TOrdemServico.existeRegistro: TOrdemServico;
var
  query: TZQuery;
//  grupoConsultado: TOrdemServico;
  sql: TStringList;
begin
//  grupoConsultado := TOrdemServico.Create;
//  sql := TStringList.Create;
//  sql.Add('SELECT CODIGO_GRUPO, DESCRICAO, `STATUS`');
//  sql.Add('  FROM grupo');
//  sql.Add(' WHERE DESCRICAO = ' + QuotedStr(FDescricao));
//
//  if (FCodigo > 0) then
//  begin
//    sql.Add('   AND CODIGO_GRUPO <> ' + IntToStrSenaoZero(FCodigo));
//  end;
//
//  sql.Add(' LIMIT 1');
//
//  query := FConexao.executarComandoDQL(sql.Text);
//
//  if not Assigned(query)
//  or (query = nil)
//  or (query.RecordCount = 0) then
//  begin
//    grupoConsultado.Destroy;
//    grupoConsultado := nil;
//  end
//  else
//  begin
//    query.First;
//    FRegistrosAfetados := FConexao.registrosAfetados;
//
//    grupoConsultado.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
//    grupoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
//    grupoConsultado.FStatus := query.FieldByName('STATUS').Value;
//  end;
//
//  Result := grupoConsultado;
//
//  FreeAndNil(sql);
end;

function TOrdemServico.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TOrdemServico.inativarOrdemServico: TOrdemServico;
var
  sql: TStringList;
begin
//  sql := TStringList.Create;
//  sql.Add('UPDATE `grupo`');
//  sql.Add('   SET `STATUS` = ''I'' ');
//  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
//  sql.Add(' WHERE CODIGO_GRUPO = ' + IntToStrSenaoZero(FCodigo));
//
//  FConexao.executarComandoDML(sql.Text);
//  FreeAndNil(sql);
//  Result := consultarCodigo(FCodigo);
end;

procedure TOrdemServico.limpar;
begin
//  FCodigo := 0;
//  FDescricao := '';
//  FCadastradoPor.limpar;
//  FAlteradoPor.limpar;
//  FDataCadastro := Now;
//  FUltimaAlteracao := Now;
//  FStatus := 'A';
//  FLimite := 0;
//  FOffset := 0;
//  FRegistrosAfetados := 0;
//  FMaisRegistro := False;
end;

function TOrdemServico.montarOrdemServico(query: TZQuery): TOrdemServico;
var
  data: TOrdemServico;
begin
//  try
//    data := TOrdemServico.Create;
//
//    data.FCodigo := query.FieldByName('CODIGO_GRUPO').Value;
//    data.FDescricao := query.FieldByName('DESCRICAO').Value;
//    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
//    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
//    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
//    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
//    data.FStatus := query.FieldByName('STATUS').Value;
//
//    Result := data;
//  except
//    on E: Exception do
//    begin
//      raise Exception.Create('Erro ao montar Grupo ' + e.Message);
//      Result := nil;
//    end;
//  end;
end;

function TOrdemServico.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
