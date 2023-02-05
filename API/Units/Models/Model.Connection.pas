unit Model.Connection;

interface

uses ZConnection, System.SysUtils, System.IniFiles, Vcl.Forms, ZDataset,
     Winapi.Windows, System.Variants, Vcl.Dialogs, IdHashMessageDigest;

type
  TConexao = class

  private
    FUsuario: string;
    FBaseDados: string;
    FCodigoSessao: integer;
    FHost: string;
    FLibaryLocation: string;
    FSenha: string;
    FPorta: integer;
    FRegistrosAfetados: integer;
    FProtoloco: string;
    procedure carregarConfiguracao();
    procedure debug(query: TZQuery);
  public
    constructor Create;
    destructor Destroy;

    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;
    property codigoSessao: Integer read FCodigoSessao;

    procedure conectar;
    procedure executarComandoDML(query: string);
    procedure atualizarLog(codigo: Integer; resposta: string);

    function executarComandoDQL(query: string): TZQuery;
    function ultimoRegistro(tabela, coluna: string): integer;
    function criarToken(token:string):string;
    function Zeros(Valor: string; Tamanho: Integer): string;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

var
  FConection: TZConnection;
  componente: TZQuery;

implementation

uses UFuncao;

procedure TConexao.conectar;
begin
  if not Assigned(FConection) then
  begin
    raise Exception.Create('Classe instanciada incorretamente, verifique!');
  end
  else if not FConection.Connected then
  begin
    FConection.Connected := True;
  end;
end;

constructor TConexao.Create;
begin
  try
    FConection := TZConnection.Create(nil);

    FProtoloco := '';
    carregarConfiguracao();
    FConection.HostName := FHost;
    FConection.User := FUsuario;
    FConection.Database := FBaseDados;
    FConection.LibraryLocation := FLibaryLocation;
    FConection.Password := FSenha;
    FConection.Port := FPorta;
    FConection.Protocol := FProtoloco;

    conectar();

    componente := TZQuery.Create(nil);
    componente.Connection := FConection;
  except
  on E: Exception do
    raise Exception.Create('Erro ao criar a conexão com o banco de dados!' +#13#10+ e.Message);
  end;
end;

procedure TConexao.atualizarLog(codigo: Integer; resposta: string);
begin
  executarComandoDML('UPDATE `log_requisicao`'
             +#13#10+'   SET log_requisicao.RESPOSTA = ' + QuotedStr(resposta)
             +#13#10+'     , log_requisicao.CODIGO_SESSAO = ' + IntToStrSenaoZero(FCodigoSessao)
             +#13#10+'     , log_requisicao.DATA_ULTIMA_ALTERACAO = CURRENT_TIMESTAMP '
             +#13#10+'     , log_requisicao.TEMPO_RESPOSTA = TIME(log_requisicao.DATA_ULTIMA_ALTERACAO) - ' 
             +#13#10+'                                       TIME(log_requisicao.DATA_CADASTRO) '
             +#13#10+' WHERE log_requisicao.CODIGO_LOG = ' + IntToStrSenaoZero(codigo) 
             );
end;

procedure TConexao.carregarConfiguracao();
var
  arquivo, teste: string;
  ini: TIniFile;
begin
  arquivo := ExtractFilePath(Application.ExeName) + 'Config.ini';

  if not FileExists(arquivo) then
  begin
    raise Exception.Create('Arquivo de configuração de banco de dados não encontrado em: ' + arquivo + '!');
  end
  else
  try
    try
      ini := TIniFile.Create(arquivo);

      FProtoloco := ini.ReadString('Parametro','Protocolo','');
      FBaseDados := ini.ReadString('Parametro','DataBase','');
      FUsuario := ini.ReadString('Parametro','Usuario','');
      FSenha := ini.ReadString('Parametro','Senha','');
      FHost := ini.ReadString('Parametro','Host','');
      FLibaryLocation := ini.ReadString('Parametro','LibraryLocation','');
      FPorta := ini.ReadInteger('Parametro','Porta',0);

      // descriptografar a base de dados
      // descriptografar o usuario do banco de dados
      // descriptografar a senha do usuario
    finally
      FreeAndNil(ini);
    end;
  except
  on E: Exception do
    raise Exception.Create('Erro ao carregar informações do arquivo de configurações: '+ e.Message + '!');
  end;
end;

destructor TConexao.Destroy;
begin
  if Assigned(componente) then
  begin
    if componente.Active then
    begin
      componente.Active := False;
    end;

    FreeAndNil(componente);
  end;

  if Assigned(FConection) then
  begin
    if FConection.Connected then
    begin
      FConection.Connected := False;
    end;

    FreeAndNil(FConection);
  end;
end;

procedure TConexao.executarComandoDML(query: string);
begin
  try
    componente.Close;
    componente.SQL.Clear;
    componente.SQL.Add(query);
    debug(componente);
    componente.ExecSQL;
    FRegistrosAfetados := componente.RowsAffected;
  except
  on E: Exception do
    raise Exception.Create('Erro ao executar um comando DML!' +#13#10+ e.Message);
  end;
end;

function TConexao.Zeros(Valor: string; Tamanho: Integer): string;
var
  i: integer;
  Caracter, XValor: string;
begin
  I := 1;
  XValor := '';
  while I < (Length(Valor) + 1) do
  begin
    Caracter := Copy(Valor, I, 1);
    if Caracter <> ',' then
      XValor := XValor + Caracter;
    I := I + 1;
  end;
  if length(XValor) < Tamanho then
  begin
    while Length(XValor) < Tamanho do
      XValor := '0' + Xvalor;
  end
  else xValor := Copy(xValor, 1, Tamanho);
  Result := XValor;
end;

function TConexao.executarComandoDQL(query: string): TZQuery;
begin
  try
    componente.Close;
    componente.SQL.Clear;
    componente.SQL.Add(query);
    debug(componente);
    componente.Open;
    FRegistrosAfetados := componente.RowsAffected;

    Result := componente;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao executar um comando DQL!' +#13#10+ e.Message);
      Result := nil;
    end;
  end;
end;

function TConexao.GerarLog(classe, procedimento, requisicao: string): integer;
var
  codigo: integer;
begin
  codigo := ultimoRegistro('log_requisicao', 'CODIGO_LOG');

  executarComandoDML('INSERT INTO `log_requisicao` (`CODIGO_LOG`, `CLASSE`, `PROCEDIMENTO`'
             +#13#10+', `REQUISICAO`, `CODIGO_SESSAO`) VALUES ( '
             +#13#10+' ' + IntToStrSenaoZero(codigo)                            //CODIGO_LOG
             +#13#10+',' + QuotedStr(classe)                                    //CLASSE
             +#13#10+',' + QuotedStr(procedimento)                              //PROCEDIMENTO
             +#13#10+',' + QuotedStr(requisicao)                                //REQUISICAO
             +#13#10+', 1'                                                      //CODIGO_SESSAO
             +#13#10+')'
             );

  if FRegistrosAfetados > 0 then
  begin
    Result := codigo;
  end
  else
  begin
    Result := 0;
  end;
end;

function TConexao.ultimoRegistro(tabela, coluna: string): integer;
begin
  if (tabela <> '') and (coluna <> '') then
  try
    componente.Close;
    componente.SQL.Clear;
    componente.SQL.Add('SELECT (IFNULL(MAX(IFNULL(' + coluna + ',0)),0) + 1) RESULTADO FROM ' + tabela);
    debug(componente);
    componente.Open;
    FRegistrosAfetados := componente.RowsAffected;

    Result := componente.FieldByName('RESULTADO').Value;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao executar um comando DQL!' +#13#10+ e.Message);
      Result := 0;
    end;
  end
  else
  begin
    raise Exception.Create('Erro ao executar um comando DQL!' +#13#10+ 'Os campos tabela e coluna devem ser informados');
    Result := 0;
  end;
end;

function TConexao.criarToken(token: string): string;
var
  md5: TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;
  try
    Result := md5.HashStringAsHex(token);
  finally
    md5.Free;
  end;
end;

procedure TConexao.debug(query: TZQuery);
var
  i: Integer;
  valor, nome, texto: string;
begin
  if ((GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) and (GetKeyState(VK_MENU) < 0)) then
  begin
    texto := query.SQL.Text;
    for i := 0 to query.Params.Count - 1 do
    begin
      valor := varToStr(query.Params[i].Value);
      nome := ':' + query.Params[i].Name;
      valor := StringReplace(valor,'''','',[rfReplaceAll]);
      valor := QuotedStr(valor);
      texto := StringReplace(texto,nome,valor,[rfReplaceAll]);
    end;

    InputBox(query.Name,'Query:', texto);
  end;
end;

function TConexao.verificarToken(token: string): Boolean;
begin
  executarComandoDQL('SELECT `sessao`.`TOKEN`, `sessao`.`CODIGO_SESSAO`'
             +#13#10+'  FROM `sessao` '
             +#13#10+' WHERE `sessao`.`TOKEN`= ' + QuotedStr(token)
             +#13#10+'   AND `sessao`.`STATUS` = ''A'' '
             +#13#10+' LIMIT 1 '
             );

  if componente.RecordCount > 0 then
  begin
    FCodigoSessao := componente.FieldByName('CODIGO_SESSAO').Value;
    Result := True;
  end
  else
  begin
    FCodigoSessao := 0;
    Result := False;
  end;
end;

end.
