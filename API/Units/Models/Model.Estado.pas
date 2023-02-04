unit Model.Estado;

interface

uses Model.Sessao, Model.Pais, System.SysUtils, ZDataset, System.Classes;

type TEstado = class

  private
    FCodigo: integer;
    FPais: TPais;
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

    function clone(estado: TEstado): TEstado;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property pais: TPais read FPais write FPais;
    property codigoIbge: string read FCodigoIbge write FCodigoIbge;
    property nome: string read FNome write FNome;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus write FStatus;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;

    procedure limpar;

    function montarEstado(query: TZQuery): TEstado;
    function consultar: TArray<TEstado>;
    function consultarCodigo(codigo: integer): TEstado;
    function consultarChave: TEstado;
    function existeRegistro: TEstado;
    function contar: integer;
    function cadastrarEstado: TEstado;
    function alterarEstado: TEstado;
    function inativarEstado: TEstado;
    function verificarToken(token: string): Boolean;
end;

implementation

uses Principal, UFuncao;

{ TEstado }

constructor TEstado.Create;
begin
  FPais := TPais.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TEstado.Destroy;
begin
  if Assigned(FPais) then
  begin
    FPais.Destroy;
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

function TEstado.existeRegistro: TEstado;
var
  query: TZQuery;
  estadoConsultado: TEstado;
  sql: TStringList;
begin
  estadoConsultado := TEstado.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ESTADO, NOME');
  sql.Add('  FROM estado');
  sql.Add(' WHERE (CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('    OR  NOME = ' + QuotedStr(FNome) + ')');

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_ESTADO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    estadoConsultado.Destroy;
    estadoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    estadoConsultado.FCodigo := query.FieldByName('CODIGO_ESTADO').Value;
    estadoConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := estadoConsultado;

  FreeAndNil(sql);
end;

procedure TEstado.limpar;
begin
  FCodigo := 0;
  FCodigoIbge := '';
  FNome := '';
  FPais.limpar;
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

function TEstado.montarEstado(query: TZQuery): TEstado;
var
  data: TEstado;
begin
  try
    data := TEstado.Create;

    data.FCodigo := query.FieldByName('CODIGO_ESTADO').Value;
    data.FPais.id := query.FieldByName('CODIGO_PAIS').Value;
    data.FPais.nome := query.FieldByName('nomePais').Value;
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
      raise Exception.Create('Erro ao montar Estado ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TEstado.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TEstado.alterarEstado: TEstado;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `estado`');
  sql.Add('   SET CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('     , NOME = ' + QuotedStr(FNome));
  sql.Add('     , CODIGO_PAIS = ' + IntToStrSenaoZero(FPais.id));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ESTADO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TEstado.inativarEstado: TEstado;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `estado`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_ESTADO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TEstado.cadastrarEstado: TEstado;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('estado', 'CODIGO_ESTADO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `estado` (`CODIGO_PAIS`, `CODIGO_ESTADO`, `CODIGO_IBGE`, `NOME`, ');
  sql.Add('`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FPais.id));                                   //CODIGO_PAIS
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_ESTADO
  sql.Add(',' + QuotedStr(FCodigoIbge));                                        //CODIGO_IBGE
  sql.Add(',' + QuotedStr(FNome));                                              //NOME
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TEstado.clone(estado: TEstado): TEstado;
var
  data: TEstado;
begin
  data := TEstado.Create;

  data.FCodigo := estado.FCodigo;
  data.FPais := estado.FPais;
  data.FCodigoIbge := estado.FCodigoIbge;
  data.FNome := estado.FNome;
  data.FCadastradoPor := estado.FCadastradoPor;
  data.FAlteradoPor := estado.FAlteradoPor;
  data.FDataCadastro := estado.FDataCadastro;
  data.FUltimaAlteracao := estado.FUltimaAlteracao;
  data.FStatus := estado.FStatus;
  data.FLimite := estado.FLimite;
  data.FOffset := estado.FOffset;
  data.FRegistrosAfetados := estado.FRegistrosAfetados;
  data.FMaisRegistro := estado.FMaisRegistro;

  result := data;
end;

function TEstado.consultar: TArray<TEstado>;
var
  query: TZQuery;
  estados: TArray<TEstado>;
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
    sql.Add('SELECT estado.CODIGO_PAIS, estado.CODIGO_ESTADO, estado.CODIGO_IBGE, estado.NOME');
    sql.Add(', estado.CODIGO_SESSAO_CADASTRO, estado.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', estado.DATA_CADASTRO, estado.DATA_ULTIMA_ALTERACAO, estado.`STATUS`, pais.NOME nomePais');
    sql.Add(', pessoaCadastro.RAZAO_SOCIAL usuarioCadastro, pessoaAlteracao.RAZAO_SOCIAL usuarioAlteracao');
    sql.Add('  FROM estado, pessoa pessoaCadastro, sessao sessaoCadastro,');
    sql.Add('       pessoa pessoaAlteracao, sessao sessaoAlteracao, pais');
    sql.Add(' WHERE 1 = 1');

    if (FCodigoIbge <> '') then
    begin
      sql.Add('   AND estado.CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
    end;

    if  (FNome <> '') then
    begin
      sql.Add('   AND estado.NOME LIKE ' + QuotedStr('%' + FNome + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND estado.CODIGO_ESTADO = ' + IntToStrSenaoZero(FCodigo));
    end;

    if  (FPais.id > 0) then
    begin
      sql.Add('   AND estado.CODIGO_PAIS = ' + IntToStrSenaoZero(FPais.id));
    end;

    if  (FPais.nome <> '') then
    begin
      sql.Add('   AND pais.NOME LIKE ' + QuotedStr('%' + FPais.nome + '%'));
    end;

    sql.Add('   AND estado.`STATUS` = ' + QuotedStr(FStatus));
    sql.Add('   AND pessoaAlteracao.CODIGO_PESSOA = sessaoAlteracao.CODIGO_PESSOA');
    sql.Add('   AND sessaoAlteracao.CODIGO_SESSAO = estado.CODIGO_SESSAO_ALTERACAO');
    sql.Add('   AND pessoaCadastro.CODIGO_PESSOA = sessaoCadastro.CODIGO_PESSOA');
    sql.Add('   AND sessaoCadastro.CODIGO_SESSAO = estado.CODIGO_SESSAO_CADASTRO');
    sql.Add('   AND pais.CODIGO_PAIS = estado.CODIGO_PAIS');
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
      SetLength(estados, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        estados[contador] := montarEstado(query);
        query.Next;
        inc(contador);
      end;

      Result := estados;
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

function TEstado.consultarChave: TEstado;
var
  query: TZQuery;
  estadoConsultado: TEstado;
  sql: TStringList;
begin
  estadoConsultado := TEstado.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_ESTADO, NOME');
  sql.Add('  FROM estado');
  sql.Add(' WHERE CODIGO_ESTADO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    estadoConsultado.Destroy;
    estadoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    estadoConsultado.FCodigo := query.FieldByName('CODIGO_ESTADO').Value;
    estadoConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := estadoConsultado;

  FreeAndNil(sql);
end;

function TEstado.consultarCodigo(codigo: integer): TEstado;
var
  query: TZQuery;
  sql: TStringList;
  estadoConsultado: TEstado;
begin
  sql := TStringList.Create;
  sql.Add('SELECT estado.CODIGO_PAIS, estado.CODIGO_ESTADO, estado.CODIGO_IBGE, estado.NOME');
  sql.Add(', estado.CODIGO_SESSAO_CADASTRO, estado.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', estado.DATA_CADASTRO, estado.DATA_ULTIMA_ALTERACAO, estado.`STATUS`, pais.NOME nomePais');
  sql.Add(', pessoaCadastro.RAZAO_SOCIAL usuarioCadastro, pessoaAlteracao.RAZAO_SOCIAL usuarioAlteracao');
  sql.Add('  FROM estado, pessoa pessoaCadastro, sessao sessaoCadastro,');
  sql.Add('       pessoa pessoaAlteracao, sessao sessaoAlteracao, pais');
  sql.Add(' WHERE CODIGO_ESTADO = ' + IntToStrSenaoZero(codigo));
  sql.Add('   AND pessoaAlteracao.CODIGO_PESSOA = sessaoAlteracao.CODIGO_PESSOA');
  sql.Add('   AND sessaoAlteracao.CODIGO_SESSAO = estado.CODIGO_SESSAO_ALTERACAO');
  sql.Add('   AND pessoaCadastro.CODIGO_PESSOA = sessaoCadastro.CODIGO_PESSOA');
  sql.Add('   AND sessaoCadastro.CODIGO_SESSAO = estado.CODIGO_SESSAO_CADASTRO');
  sql.Add('   AND pais.CODIGO_PAIS = estado.CODIGO_PAIS');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    estadoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    estadoConsultado := montarEstado(query);
  end;

  Result := estadoConsultado;
  FreeAndNil(sql);
end;

function TEstado.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(estado.CODIGO_ESTADO) TOTAL');
  sql.Add('  FROM estado, pais');
  sql.Add(' WHERE (1 = 1)');

  if (FCodigoIbge <> '') then
  begin
    sql.Add('   AND estado.CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
  end;

  if  (FNome <> '') then
  begin
    sql.Add('   AND estado.NOME LIKE ' + QuotedStr('%' + FNome + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND estado.CODIGO_ESTADO = ' + IntToStrSenaoZero(FCodigo));
  end;

  if  (FPais.id > 0) then
  begin
    sql.Add('   AND estado.CODIGO_PAIS = ' + IntToStrSenaoZero(FPais.id));
  end;

  if  (FPais.nome <> '') then
  begin
    sql.Add('   AND pais.NOME LIKE ' + QuotedStr('%' + FPais.nome + '%'));
  end;

  sql.Add('   AND estado.`STATUS` = ' + QuotedStr(FStatus));
  sql.Add('   AND pais.CODIGO_PAIS = estado.CODIGO_PAIS');

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
