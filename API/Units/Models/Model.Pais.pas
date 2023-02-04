unit Model.Pais;

interface

uses Model.Sessao, Model.Connection, ZDataset, System.Classes, System.SysUtils,
     UFuncao;

type TPais = class

  private
    FCodigo: integer;
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

    function clone(pais: TPais): TPais;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;
    property codigoIbge: string read FCodigoIbge write FCodigoIbge;
    property nome: string read FNome write FNome;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao write FUltimaAlteracao;
    property status: string read FStatus write FStatus;

    procedure limpar;

    function montarPais(query: TZQuery): TPais;
    function consultar: TArray<TPais>;
    function consultarCodigo(codigo: integer): TPais;
    function consultarChave: TPais;
    function existeRegistro: TPais;
    function contar: integer;
    function cadastrarPais: TPais;
    function alterarPais: TPais;
    function inativarPais: TPais;
    function verificarToken(token: string): Boolean;
end;

implementation

uses Principal;

{ TPais }

constructor TPais.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TPais.Destroy;
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

function TPais.existeRegistro: TPais;
var
  query: TZQuery;
  paisConsultado: TPais;
  sql: TStringList;
begin
  paisConsultado := TPais.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PAIS, NOME');
  sql.Add('  FROM pais');
  sql.Add(' WHERE (CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('    OR  NOME = ' + QuotedStr(FNome) + ')');

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_PAIS <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    paisConsultado.Destroy;
    paisConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    paisConsultado.FCodigo := query.FieldByName('CODIGO_PAIS').Value;
    paisConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := paisConsultado;

  FreeAndNil(sql);
end;

procedure TPais.limpar;
begin
  FCodigo := 0;
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

function TPais.montarPais(query: TZQuery): TPais;
var
  data: TPais;
begin
  try
    data := TPais.Create;
    data.FCodigo := query.FieldByName('CODIGO_PAIS').Value;
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
      raise Exception.Create('Erro ao montar Pais ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TPais.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TPais.alterarPais: TPais;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pais`');
  sql.Add('   SET CODIGO_IBGE = ' + QuotedStr(FCodigoIbge));
  sql.Add('     , NOME = ' + QuotedStr(FNome));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_PAIS = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TPais.inativarPais: TPais;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pais`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_PAIS = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TPais.cadastrarPais: TPais;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('pais', 'CODIGO_PAIS');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `pais` (`CODIGO_PAIS`, `CODIGO_IBGE`, `NOME`, ');
  sql.Add('`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_PAIS
  sql.Add(',' + QuotedStr(FCodigoIbge));                                        //CODIGO_IBGE
  sql.Add(',' + QuotedStr(FNome));                                              //NOME
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TPais.clone(pais: TPais): TPais;
var
  data: TPais;
begin
  data := TPais.Create;

  data.FCodigo := pais.FCodigo;
  data.FCodigoIbge := pais.FCodigoIbge;
  data.FNome := pais.FNome;
  data.FCadastradoPor := pais.FCadastradoPor;
  data.FAlteradoPor := pais.FAlteradoPor;
  data.FDataCadastro := pais.FDataCadastro;
  data.FUltimaAlteracao := pais.FUltimaAlteracao;
  data.FStatus := pais.FStatus;
  data.FLimite := pais.FLimite;
  data.FOffset := pais.FOffset;
  data.FRegistrosAfetados := pais.FRegistrosAfetados;
  data.FMaisRegistro := pais.FMaisRegistro;

  result := data;
end;

function TPais.consultar: TArray<TPais>;
var
  query: TZQuery;
  paises: TArray<TPais>;
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
    sql.Add('SELECT pais.CODIGO_PAIS, pais.CODIGO_IBGE, pais.NOME, pais.CODIGO_SESSAO_CADASTRO');
    sql.Add(', pais.CODIGO_SESSAO_ALTERACAO, pais.DATA_CADASTRO, pais.DATA_ULTIMA_ALTERACAO, pais.`STATUS`');
    sql.Add(', pessoaCadastro.RAZAO_SOCIAL usuarioCadastro, pessoaAlteracao.RAZAO_SOCIAL usuarioAlteracao');
    sql.Add('  FROM pais, pessoa pessoaCadastro, sessao sessaoCadastro,');
    sql.Add('       pessoa pessoaAlteracao, sessao sessaoAlteracao');
    sql.Add(' WHERE 1 = 1');

    if (FCodigoIbge <> '') then
    begin
      sql.Add('   AND pais.CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
    end;

    if  (FNome <> '') then
    begin
      sql.Add('   AND pais.NOME LIKE ' + QuotedStr('%' + FNome + '%'));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND pais.CODIGO_PAIS = ' + IntToStrSenaoZero(FCodigo));
    end;

    sql.Add('   AND pais.`STATUS` = ' + QuotedStr(FStatus));
    sql.Add('   AND pessoaAlteracao.CODIGO_PESSOA = sessaoAlteracao.CODIGO_PESSOA');
    sql.Add('   AND sessaoAlteracao.CODIGO_SESSAO = pais.CODIGO_SESSAO_ALTERACAO');
    sql.Add('   AND pessoaCadastro.CODIGO_PESSOA = sessaoCadastro.CODIGO_PESSOA');
    sql.Add('   AND sessaoCadastro.CODIGO_SESSAO = pais.CODIGO_SESSAO_CADASTRO');
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
      SetLength(paises, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        paises[contador] := montarPais(query);
        query.Next;
        inc(contador);
      end;

      Result := paises;
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

function TPais.consultarChave: TPais;
var
  query: TZQuery;
  paisConsultado: TPais;
  sql: TStringList;
begin
  paisConsultado := TPais.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_PAIS, NOME');
  sql.Add('  FROM pais');
  sql.Add(' WHERE CODIGO_PAIS = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    paisConsultado.Destroy;
    paisConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    paisConsultado.FCodigo := query.FieldByName('CODIGO_PAIS').Value;
    paisConsultado.FNome := query.FieldByName('NOME').Value;
  end;

  Result := paisConsultado;

  FreeAndNil(sql);
end;

function TPais.consultarCodigo(codigo: integer): TPais;
var
  query: TZQuery;
  sql: TStringList;
  paisConsultado: TPais;
begin
  sql := TStringList.Create;
  sql.Add('SELECT pais.CODIGO_PAIS, pais.CODIGO_IBGE, pais.NOME, pais.CODIGO_SESSAO_CADASTRO');
  sql.Add(', pais.CODIGO_SESSAO_ALTERACAO, pais.DATA_CADASTRO, pais.DATA_ULTIMA_ALTERACAO, pais.`STATUS`');
  sql.Add(', pessoaCadastro.RAZAO_SOCIAL usuarioCadastro, pessoaAlteracao.RAZAO_SOCIAL usuarioAlteracao');
  sql.Add('  FROM pais, pessoa pessoaCadastro, sessao sessaoCadastro,');
  sql.Add('       pessoa pessoaAlteracao, sessao sessaoAlteracao');
  sql.Add(' WHERE pais.CODIGO_PAIS = ' + IntToStrSenaoZero(codigo));
  sql.Add('	  AND pessoaAlteracao.CODIGO_PESSOA = sessaoAlteracao.CODIGO_PESSOA');
  sql.Add('	  AND sessaoAlteracao.CODIGO_SESSAO = pais.CODIGO_SESSAO_ALTERACAO');
  sql.Add('	  AND pessoaCadastro.CODIGO_PESSOA = sessaoCadastro.CODIGO_PESSOA');
  sql.Add('	  AND sessaoCadastro.CODIGO_SESSAO = pais.CODIGO_SESSAO_CADASTRO');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    paisConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    paisConsultado := montarPais(query);
  end;

  Result := paisConsultado;
  FreeAndNil(sql);
end;

function TPais.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(CODIGO_PAIS) TOTAL');
  sql.Add('  FROM pais');
  sql.Add(' WHERE (1 = 1)');

  if (FCodigoIbge <> '') then
  begin
    sql.Add('   AND CODIGO_IBGE LIKE ' + QuotedStr('%' + FCodigoIbge + '%'));
  end;

  if  (FNome <> '') then
  begin
    sql.Add('   AND NOME LIKE ' + QuotedStr('%' + FNome + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_PAIS = ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add('   AND `STATUS` = ' + QuotedStr(FStatus));

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
