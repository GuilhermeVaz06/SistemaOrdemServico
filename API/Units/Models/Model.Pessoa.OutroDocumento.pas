unit Model.Pessoa.OutroDocumento;

interface

uses Model.Sessao, Model.Pessoa, Model.TipoDocumento, System.SysUtils, ZDataset,
     System.Classes;

type TOutroDocumento = class

  private
    FCodigo: integer;
    FPessoa: TPessoa;
    FTipoDocumento: TTipoDocumento;
    FDocumento: string;
    FDataEmissao: TDate;
    FDataVencimento: TDate;
    FObservacao: string;
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
    function consultarCodigo(codigo: integer): TOutroDocumento;
    function montarOutroDocumento(query: TZQuery): TOutroDocumento;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property pessoa: TPessoa read FPessoa write FPessoa;
    property tipoDocumento: TTipoDocumento read FTipoDocumento write FTipoDocumento;
    property documento: string read FDocumento write FDocumento;
    property dataEmissao: TDate read FDataEmissao write FDataEmissao;
    property dataVencimento: TDate read FDataVencimento write FDataVencimento;
    property observacao: string read FObservacao write FObservacao;
    property cadastradoPor: TSessao read FCadastradoPor write FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor write FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus write FStatus;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;

    procedure limpar;
    procedure atualizarLog(codigo, status: Integer; resposta: string);

    function consultar: TArray<TOutroDocumento>;
    function consultarChave: TOutroDocumento;
    function existeRegistro: TOutroDocumento;
    function cadastrarOutroDocumento: TOutroDocumento;
    function alterarOutroDocumento: TOutroDocumento;
    function inativarOutroDocumento: TOutroDocumento;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses Principal, UFuncao;

{ TOutroDocumento }

constructor TOutroDocumento.Create;
begin
  FPessoa := TPessoa.Create;
  FTipoDocumento := TTipoDocumento.Create;
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  inherited;
end;

destructor TOutroDocumento.Destroy;
begin
  if Assigned(FPessoa) then
  begin
    FPessoa.Destroy;
  end;

  if Assigned(FTipoDocumento) then
  begin
    FTipoDocumento.Destroy;
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

function TOutroDocumento.existeRegistro: TOutroDocumento;
var
  query: TZQuery;
  outroDocumentoConsultado: TOutroDocumento;
  sql: TStringList;
begin
  outroDocumentoConsultado := TOutroDocumento.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_OUTRO_DOCUMENTO, DOCUMENTO, `STATUS`');
  sql.Add('  FROM pessoa_outro_documento');
  sql.Add(' WHERE CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  sql.Add('   AND CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
  sql.Add('   AND DOCUMENTO = ' + QuotedStr(FDocumento));

  if (FCodigo > 0) then
  begin
    sql.Add('   AND CODIGO_OUTRO_DOCUMENTO <> ' + IntToStrSenaoZero(FCodigo));
  end;

  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    outroDocumentoConsultado.Destroy;
    outroDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    outroDocumentoConsultado.FCodigo := query.FieldByName('CODIGO_OUTRO_DOCUMENTO').Value;
    outroDocumentoConsultado.FDocumento := query.FieldByName('DOCUMENTO').Value;
    outroDocumentoConsultado.FStatus := query.FieldByName('STATUS').Value;
  end;

  Result := outroDocumentoConsultado;

  FreeAndNil(sql);
end;

function TOutroDocumento.GerarLog(classe, procedimento, requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

procedure TOutroDocumento.limpar;
begin
  FCodigo := 0;
  FPessoa.limpar;
  FTipoDocumento.limpar;
  FDocumento := '';
  FDataEmissao := Date;
  FDataVencimento := Date;
  FObservacao := '';
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

function TOutroDocumento.montarOutroDocumento(query: TZQuery): TOutroDocumento;
var
  data: TOutroDocumento;
begin
  try
    data := TOutroDocumento.Create;

    data.FCodigo := query.FieldByName('CODIGO_OUTRO_DOCUMENTO').Value;
    data.FPessoa.id := query.FieldByName('CODIGO_PESSOA').Value;
    data.FTipoDocumento.id := query.FieldByName('CODIGO_TIPO_DOCUMENTO').Value;
    data.FTipoDocumento.descricao := query.FieldByName('tipoDocumento').Value;
    data.FTipoDocumento.mascara := query.FieldByName('mascaraDocumento').Value;
    data.FDocumento := query.FieldByName('DOCUMENTO').Value;
    data.FDataEmissao := query.FieldByName('DT_EMISSAO').Value;
    data.FDataVencimento := query.FieldByName('DT_VENCIMENTO').Value;
    data.FObservacao := query.FieldByName('OBSERVACAO').AsString;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Cidade ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TOutroDocumento.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

function TOutroDocumento.alterarOutroDocumento: TOutroDocumento;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_outro_documento`');
  sql.Add('   SET CODIGO_TIPO_DOCUMENTO = ' + IntToStrSenaoZero(FTipoDocumento.id));
  sql.Add('     , DOCUMENTO = ' + QuotedStr(FDocumento));
  sql.Add('     , DT_EMISSAO = ' + DataBD(FDataEmissao));
  sql.Add('     , DT_VENCIMENTO = ' + DataBD(FDataVencimento));
  sql.Add('     , OBSERVACAO = ' + QuotedStr(FObservacao));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OUTRO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

function TOutroDocumento.inativarOutroDocumento: TOutroDocumento;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `pessoa_outro_documento`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OUTRO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TOutroDocumento.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TOutroDocumento.cadastrarOutroDocumento: TOutroDocumento;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('pessoa_outro_documento', 'CODIGO_OUTRO_DOCUMENTO');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `pessoa_outro_documento` (`CODIGO_PESSOA`, `CODIGO_OUTRO_DOCUMENTO` ');
  sql.Add(', `CODIGO_TIPO_DOCUMENTO`, `DOCUMENTO`, `DT_EMISSAO`, `DT_VENCIMENTO`, `OBSERVACAO`');
  sql.Add(', `CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(FPessoa.id));                                 //CODIGO_PESSOA
  sql.Add(',' + IntToStrSenaoZero(codigo));                                     //CODIGO_OUTRO_DOCUMENTO
  sql.Add(',' + IntToStrSenaoZero(FTipoDocumento.id));                          //CODIGO_TIPO_DOCUMENTO
  sql.Add(',' + QuotedStr(FDocumento));                                         //DOCUMENTO
  sql.Add(',' + DataBD(FDataEmissao));                                          //DT_EMISSAO
  sql.Add(',' + DataBD(FDataVencimento));                                       //DT_VENCIMENTO
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TOutroDocumento.consultar: TArray<TOutroDocumento>;
var
  query: TZQuery;
  outrosDocumentos: TArray<TOutroDocumento>;
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
    sql.Add('SELECT pessoa_outro_documento.CODIGO_PESSOA, pessoa_outro_documento.CODIGO_OUTRO_DOCUMENTO');
    sql.Add(', pessoa_outro_documento.CODIGO_TIPO_DOCUMENTO, pessoa_outro_documento.DOCUMENTO ');
    sql.Add(', pessoa_outro_documento.DT_EMISSAO, pessoa_outro_documento.DT_VENCIMENTO');
    sql.Add(', pessoa_outro_documento.OBSERVACAO, pessoa_outro_documento.CODIGO_SESSAO_CADASTRO');
    sql.Add(', pessoa_outro_documento.CODIGO_SESSAO_ALTERACAO, pessoa_outro_documento.DATA_CADASTRO');
    sql.Add(', pessoa_outro_documento.DATA_ULTIMA_ALTERACAO, pessoa_outro_documento.`STATUS`');
    sql.Add(', tipo_documento.DESCRICAO tipoDocumento, tipo_documento.MASCARA_CARACTERES mascaraDocumento');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_outro_documento.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_outro_documento.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('  FROM pessoa_outro_documento, pessoa, tipo_documento');
    sql.Add(' WHERE pessoa_outro_documento.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');
    sql.Add('   AND pessoa_outro_documento.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');

    if (FPessoa.id > 0) then
    begin
      sql.Add('   AND pessoa.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
    end;

    if (FCodigo > 0) then
    begin
      sql.Add('   AND pessoa_outro_documento.CODIGO_OUTRO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));
    end;

    sql.Add('   AND pessoa_outro_documento.`STATUS` = ' + QuotedStr(FStatus));
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
      SetLength(outrosDocumentos, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        outrosDocumentos[contador] := montarOutroDocumento(query);
        query.Next;
        inc(contador);
      end;

      Result := outrosDocumentos;
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

function TOutroDocumento.consultarChave: TOutroDocumento;
var
  query: TZQuery;
  outroDocumentoConsultado: TOutroDocumento;
  sql: TStringList;
begin
  outroDocumentoConsultado := TOutroDocumento.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_OUTRO_DOCUMENTO, DOCUMENTO');
  sql.Add('  FROM pessoa_outro_documento');
  sql.Add(' WHERE CODIGO_OUTRO_DOCUMENTO = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    outroDocumentoConsultado.Destroy;
    outroDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    outroDocumentoConsultado.FCodigo := query.FieldByName('CODIGO_OUTRO_DOCUMENTO').Value;
    outroDocumentoConsultado.FDocumento := query.FieldByName('DOCUMENTO').Value;
  end;

  Result := outroDocumentoConsultado;

  FreeAndNil(sql);
end;

function TOutroDocumento.consultarCodigo(codigo: integer): TOutroDocumento;
var
  query: TZQuery;
  sql: TStringList;
  outroDocumentoConsultado: TOutroDocumento;
begin
  sql := TStringList.Create;
  sql.Add('SELECT pessoa_outro_documento.CODIGO_PESSOA, pessoa_outro_documento.CODIGO_OUTRO_DOCUMENTO');
  sql.Add(', pessoa_outro_documento.CODIGO_TIPO_DOCUMENTO, pessoa_outro_documento.DOCUMENTO ');
  sql.Add(', pessoa_outro_documento.DT_EMISSAO, pessoa_outro_documento.DT_VENCIMENTO');
  sql.Add(', pessoa_outro_documento.OBSERVACAO, pessoa_outro_documento.CODIGO_SESSAO_CADASTRO');
  sql.Add(', pessoa_outro_documento.CODIGO_SESSAO_ALTERACAO, pessoa_outro_documento.DATA_CADASTRO');
  sql.Add(', pessoa_outro_documento.DATA_ULTIMA_ALTERACAO, pessoa_outro_documento.`STATUS`');
  sql.Add(', tipo_documento.DESCRICAO tipoDocumento, tipo_documento.MASCARA_CARACTERES mascaraDocumento');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_outro_documento.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = pessoa_outro_documento.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('  FROM pessoa_outro_documento, pessoa, tipo_documento');
  sql.Add(' WHERE pessoa_outro_documento.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');
  sql.Add('   AND pessoa_outro_documento.CODIGO_TIPO_DOCUMENTO = tipo_documento.CODIGO_TIPO_DOCUMENTO');
  sql.Add('   AND pessoa_outro_documento.CODIGO_OUTRO_DOCUMENTO = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    outroDocumentoConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    outroDocumentoConsultado := montarOutroDocumento(query);
  end;

  Result := outroDocumentoConsultado;
  FreeAndNil(sql);
end;

function TOutroDocumento.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(pessoa_outro_documento.CODIGO_OUTRO_DOCUMENTO) TOTAL');
  sql.Add('  FROM pessoa_outro_documento, pessoa');
  sql.Add(' WHERE pessoa_outro_documento.CODIGO_PESSOA = pessoa.CODIGO_PESSOA');

  if (FPessoa.id > 0) then
  begin
    sql.Add('   AND pessoa.CODIGO_PESSOA = ' + IntToStrSenaoZero(FPessoa.id));
  end;

  sql.Add('   AND pessoa_outro_documento.`STATUS` = ' + QuotedStr(FStatus));

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
