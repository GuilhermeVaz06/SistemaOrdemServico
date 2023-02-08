unit Model.TipoEndereco;

interface

uses system.SysUtils, Model.Sessao, ZDataset, System.Classes;

type TTipoEndereco = class

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
    function montarTipoEndereco(query: TZQuery): TTipoEndereco;
    function consultarCodigo(codigo: integer): TTipoEndereco;

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
    procedure atualizarLog(codigo: Integer; resposta: string);
    function consultar: TArray<TTipoEndereco>;
    function consultarChave: TTipoEndereco;
    function existeRegistro: TTipoEndereco;
    function cadastrarTipoEndereco: TTipoEndereco;
    function alterarTipoEndereco: TTipoEndereco;
    function inativarTipoEndereco: TTipoEndereco;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;

end;

implementation

uses UFuncao, Principal;

{ TTipoEndereco }

function TTipoEndereco.alterarTipoEndereco: TTipoEndereco;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `tipo_endereco`');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TTipoEndereco.atualizarLog(codigo: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, resposta);
end;

function TTipoEndereco.cadastrarTipoEndereco: TTipoEndereco;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('tipo_endereco', 'CODIGO_TIPO_ENDERECO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `tipo_documento` (`CODIGO_TIPO_ENDERECO`, `DESCRICAO`');
  sql.Add('`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_TIPO_ENDERECO
  sql.Add(',' + QuotedStr(FDescricao));                                         //DESCRICAO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TTipoEndereco.consultar: TArray<TTipoEndereco>;
var
  query: TZQuery;
  tipoEndereco: TArray<TTipoEndereco>;
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
    sql.Add('SELECT tipo_endereco.CODIGO_TIPO_ENDERECO, tipo_endereco.DESCRICAO, tipo_endereco.CODIGO_SESSAO_CADASTRO');
    sql.Add(', tipo_endereco.CODIGO_SESSAO_ALTERACAO, tipo_endereco.DATA_CADASTRO, tipo_endereco.DATA_ULTIMA_ALTERACAO');
    sql.Add(', tipo_endereco.`STATUS`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = tipo_endereco.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = tipo_endereco.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM tipo_endereco');
    sql.Add(' WHERE tipo_endereco.`STATUS` = ' + QuotedStr(FStatus));

    if (FDescricao <> '') then
    begin
      sql.Add('   AND tipo_endereco.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND tipo_endereco.CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
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
      SetLength(tipoEndereco, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        tipoEndereco[contador] := montarTipoEndereco(query);
        query.Next;
        inc(contador);
      end;

      Result := tipoEndereco;
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

function TTipoEndereco.consultarChave: TTipoEndereco;
var
  query: TZQuery;
  tipoEnderecoConsultado: TTipoEndereco;
  sql: TStringList;
begin
  tipoEnderecoConsultado := TTipoEndereco.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_TIPO_ENDERECO, DESCRICAO');
  sql.Add('  FROM tipo_endereco');
  sql.Add(' WHERE CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoEnderecoConsultado.Destroy;
    tipoEnderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    tipoEnderecoConsultado.FCodigo := query.FieldByName('CODIGO_TIPO_ENDERECO').Value;
    tipoEnderecoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := tipoEnderecoConsultado;

  FreeAndNil(sql);
end;

function TTipoEndereco.consultarCodigo(codigo: integer): TTipoEndereco;
var
  query: TZQuery;
  sql: TStringList;
  tipoEnderecoConsultado: TTipoEndereco;
begin
  sql := TStringList.Create;
  sql.Add('SELECT tipo_endereco.CODIGO_TIPO_ENDERECO, tipo_endereco.DESCRICAO, tipo_endereco.CODIGO_SESSAO_CADASTRO');
  sql.Add(', tipo_endereco.CODIGO_SESSAO_ALTERACAO, tipo_endereco.DATA_CADASTRO, tipo_endereco.DATA_ULTIMA_ALTERACAO');
  sql.Add(', tipo_endereco.`STATUS`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = tipo_endereco.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = tipo_endereco.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM tipo_endereco');
  sql.Add(' WHERE tipo_endereco.CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoEnderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    tipoEnderecoConsultado := montarTipoEndereco(query);
  end;

  Result := tipoEnderecoConsultado;
  FreeAndNil(sql);
end;

function TTipoEndereco.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(tipo_endereco.CODIGO_TIPO_ENDERECO) TOTAL');
  sql.Add('  FROM tipo_endereco');
  sql.Add(' WHERE tipo_endereco.`STATUS` = ' + QuotedStr(FStatus));

  if (FDescricao <> '') then
  begin
    sql.Add('   AND tipo_endereco.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND tipo_endereco.CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));
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

constructor TTipoEndereco.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

destructor TTipoEndereco.Destroy;
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

function TTipoEndereco.existeRegistro: TTipoEndereco;
var
  query: TZQuery;
  tipoEnderecoConsultado: TTipoEndereco;
  sql: TStringList;
begin
  tipoEnderecoConsultado := TTipoEndereco.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_TIPO_ENDERECO, DESCRICAO');
  sql.Add('  FROM tipo_endereco');
  sql.Add(' WHERE DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_TIPO_ENDERECO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoEnderecoConsultado.Destroy;
    tipoEnderecoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    tipoEnderecoConsultado.FCodigo := query.FieldByName('CODIGO_TIPO_ENDERECO').Value;
    tipoEnderecoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := tipoEnderecoConsultado;

  FreeAndNil(sql);
end;

function TTipoEndereco.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TTipoEndereco.inativarTipoEndereco: TTipoEndereco;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `tipo_endereco`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_TIPO_ENDERECO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TTipoEndereco.limpar;
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

function TTipoEndereco.montarTipoEndereco(query: TZQuery): TTipoEndereco;
var
  data: TTipoEndereco;
begin
  try
    data := TTipoEndereco.Create;

    data.FCodigo := query.FieldByName('CODIGO_TIPO_ENDERECO').Value;
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
      raise Exception.Create('Erro ao montar Tipo Endereço ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TTipoEndereco.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
