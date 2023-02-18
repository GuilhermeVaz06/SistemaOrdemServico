unit Model.TipoDocumento;

interface

uses system.SysUtils, Model.Sessao, ZDataset, System.Classes;

type
  TTipoDocumento = class

  private
    FCodigo: integer;
    FDescricao: string;
    FQtdeCaracteres: integer;
    FMascara: string;
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
    function montarTipoDocumento(query: TZQuery): TTipoDocumento;
    function consultarCodigo(codigo: integer): TTipoDocumento;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property descricao: string read FDescricao write FDescricao;
    property qtdeCaracteres: Integer read FQtdeCaracteres write FQtdeCaracteres;
    property mascara: string read FMascara write FMascara;
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
    function buscarRegistroCadastrar(descricao, mascara: string; caracteres: integer): integer;

    function consultar: TArray<TTipoDocumento>;
    function consultarChave: TTipoDocumento;
    function existeRegistro: TTipoDocumento;
    function cadastrarTipoDocumento: TTipoDocumento;
    function alterarTipoDocumento: TTipoDocumento;
    function inativarTipoDocumento: TTipoDocumento;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses UFuncao, Principal;

{ TTipoDocumento }

function TTipoDocumento.alterarTipoDocumento: TTipoDocumento;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `tipo_documento`');
  sql.Add('   SET DESCRICAO = ' + QuotedStr(FDescricao));
  sql.Add('     , QTDE_CARACTERES = ' + IntToStrSenaoZero(FQtdeCaracteres));
  sql.Add('     , MASCARA_CARACTERES = ' + QuotedStr(FMascara));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TTipoDocumento.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TTipoDocumento.buscarRegistroCadastrar(descricao, mascara: string; caracteres: integer): integer;
var
  tipoDocumentoConsultado: TTipoDocumento;
begin
  FDescricao := descricao;
  tipoDocumentoConsultado := existeRegistro;

  if Assigned(tipoDocumentoConsultado) then
  begin
    Result := tipoDocumentoConsultado.id;
    tipoDocumentoConsultado.Destroy;
  end
  else
  begin
    FMascara := mascara;
    FQtdeCaracteres := caracteres;
    tipoDocumentoConsultado := cadastrarTipoDocumento;
    Result := tipoDocumentoConsultado.id;
    tipoDocumentoConsultado.Destroy;
  end;
end;

function TTipoDocumento.cadastrarTipoDocumento: TTipoDocumento;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('tipo_documento', 'CODIGO_TIPO_DOCUMENTO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `tipo_documento` (`CODIGO_TIPO_DOCUMENTO`, `DESCRICAO`, `QTDE_CARACTERES`, `MASCARA_CARACTERES`, ');
  sql.Add('`CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_TIPO_DOCUMENTO
  sql.Add(',' + QuotedStr(FDescricao));                                         //DESCRICAO
  sql.Add(',' + IntToStrSenaoZero(FQtdeCaracteres));                            //QTDE_CARACTERES
  sql.Add(',' + QuotedStr(FMascara));                                           //MASCARA_CARACTERES
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TTipoDocumento.consultar: TArray<TTipoDocumento>;
var
  query: TZQuery;
  tipoDocumento: TArray<TTipoDocumento>;
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
    sql.Add('SELECT tipo_documento.CODIGO_TIPO_DOCUMENTO, tipo_documento.DESCRICAO, tipo_documento.QTDE_CARACTERES');
    sql.Add(', tipo_documento.MASCARA_CARACTERES, tipo_documento.CODIGO_SESSAO_CADASTRO, tipo_documento.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', tipo_documento.DATA_CADASTRO, tipo_documento.DATA_ULTIMA_ALTERACAO, tipo_documento.`STATUS`');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = tipo_documento.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = tipo_documento.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM tipo_documento');
    sql.Add(' WHERE tipo_documento.`STATUS` = ' + QuotedStr(FStatus));

    if (FDescricao <> '') then
    begin
      sql.Add('   AND tipo_documento.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
    end;

    if (FMascara <> '') then
    begin
      sql.Add('   AND tipo_documento.MASCARA_CARACTERES LIKE ' + QuotedStr('%' + FMascara + '%'));
    end;

    if  (FQtdeCaracteres > 0) then
    begin
      sql.Add('   AND tipo_documento.QTDE_CARACTERES = ' + IntToStrSenaoZero(FQtdeCaracteres));
    end;

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND tipo_documento.CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));
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
      SetLength(tipoDocumento, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        tipoDocumento[contador] := montarTipoDocumento(query);
        query.Next;
        inc(contador);
      end;

      Result := tipoDocumento;
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

function TTipoDocumento.consultarChave: TTipoDocumento;
var
  query: TZQuery;
  tipoDocumentoConsultado: TTipoDocumento;
  sql: TStringList;
begin
  tipoDocumentoConsultado := TTipoDocumento.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_TIPO_DOCUMENTO, DESCRICAO, QTDE_CARACTERES');
  sql.Add('  FROM tipo_documento');
  sql.Add(' WHERE CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoDocumentoConsultado.Destroy;
    tipoDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    tipoDocumentoConsultado.FCodigo := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    tipoDocumentoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    tipoDocumentoConsultado.FQtdeCaracteres := query.FieldByName('QTDE_CARACTERES').Value;
  end;

  Result := tipoDocumentoConsultado;

  FreeAndNil(sql);
end;

function TTipoDocumento.consultarCodigo(codigo: integer): TTipoDocumento;
var
  query: TZQuery;
  sql: TStringList;
  tipoDocumentoConsultado: TTipoDocumento;
begin
  sql := TStringList.Create;
  sql.Add('SELECT tipo_documento.CODIGO_TIPO_DOCUMENTO, tipo_documento.DESCRICAO, tipo_documento.QTDE_CARACTERES');
  sql.Add(', tipo_documento.MASCARA_CARACTERES, tipo_documento.CODIGO_SESSAO_CADASTRO, tipo_documento.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', tipo_documento.DATA_CADASTRO, tipo_documento.DATA_ULTIMA_ALTERACAO, tipo_documento.`STATUS`');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = tipo_documento.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = tipo_documento.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM tipo_documento');
  sql.Add(' WHERE tipo_documento.CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    tipoDocumentoConsultado := montarTipoDocumento(query);
  end;

  Result := tipoDocumentoConsultado;
  FreeAndNil(sql);
end;

function TTipoDocumento.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(tipo_documento.CODIGO_TIPO_DOCUMENTO) TOTAL');
  sql.Add('  FROM tipo_documento');
  sql.Add(' WHERE tipo_documento.`STATUS` = ' + QuotedStr(FStatus));

  if (FDescricao <> '') then
  begin
    sql.Add('   AND tipo_documento.DESCRICAO LIKE ' + QuotedStr('%' + FDescricao + '%'));
  end;

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND tipo_documento.CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));
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

constructor TTipoDocumento.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;

  inherited;
end;

destructor TTipoDocumento.Destroy;
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

function TTipoDocumento.existeRegistro: TTipoDocumento;
var
  query: TZQuery;
  tipoDocumentoConsultado: TTipoDocumento;
  sql: TStringList;
begin
  tipoDocumentoConsultado := TTipoDocumento.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_TIPO_DOCUMENTO, DESCRICAO, `STATUS`');
  sql.Add('  FROM tipo_documento');
  sql.Add(' WHERE DESCRICAO = ' + QuotedStr(FDescricao));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_TIPO_DOCUMENTO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoDocumentoConsultado.Destroy;
    tipoDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    tipoDocumentoConsultado.FCodigo := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    tipoDocumentoConsultado.FDescricao := query.FieldByName('DESCRICAO').Value;
    tipoDocumentoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := tipoDocumentoConsultado;

  FreeAndNil(sql);
end;

function TTipoDocumento.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TTipoDocumento.inativarTipoDocumento: TTipoDocumento;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `tipo_documento`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TTipoDocumento.limpar;
begin
  FCodigo := 0;
  FDescricao := '';
  FQtdeCaracteres := 0;
  FMascara := '';
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

function TTipoDocumento.montarTipoDocumento(query: TZQuery): TTipoDocumento;
var
  data: TTipoDocumento;
begin
  try
    data := TTipoDocumento.Create;

    data.FCodigo := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    data.FDescricao := query.FieldByName('DESCRICAO').Value;
    data.FQtdeCaracteres := query.FieldByName('QTDE_CARACTERES').Value;
    data.FMascara := query.FieldByName('MASCARA_CARACTERES').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Tipo Documento ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TTipoDocumento.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
