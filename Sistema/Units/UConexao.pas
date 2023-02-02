unit UConexao;

interface

uses
  REST.Types, REST.Client, System.SysUtils, System.IniFiles, Vcl.Forms,
  System.JSON;

type
  TConexao = class

  private
    FCliente: TRESTClient;
    FRequest: TRESTRequest;
    FUrlCompleta: string;
    FUrl: string;
    FUrlBase: string;
    FErro: string;
    FBody: TJSONObject;
    FResposta: string;
    FTimeOut: integer;
    FStatus: integer;
    FMetodo: TRESTRequestMethod;

    procedure AtribuirUrl;
    procedure Configurar;
    procedure CarregarIP;

  public
    property url: string read FUrl write FUrl;
    property erro: string read FErro write FErro;
    property resposta: string read FResposta write FResposta;
    property status: integer read FStatus write FStatus;
    property metodo: TRESTRequestMethod read FMetodo write FMetodo;

    constructor Create;
    destructor Destroy;

    procedure Limpar;
    procedure Enviar;
    procedure AtribuirParametro(chave, valor: string);
    procedure AtribuirBody(chave, valor: string);
    procedure TratarErro;
end;

implementation

uses UFuncao;

{ TConexao }

procedure TConexao.AtribuirBody(chave, valor: string);
begin
  if (chave <> '') and (valor <> '') and (Assigned(FBody)) then
  begin
    FBody.AddPair(chave, valor);
  end;
end;

procedure TConexao.AtribuirParametro(chave, valor: string);
begin
  if (chave <> '') and (valor <> '') and (Assigned(FRequest)) then
  begin
    FRequest.AddParameter(chave, valor);
  end;
end;

procedure TConexao.AtribuirUrl;
begin
  if (FUrl <> '') then
  begin
    FUrlCompleta := FUrlBase + '/' + FUrl;
  end;
end;

procedure TConexao.CarregarIP;
var
  arquivo, endereco, porta: string;
  ini: TIniFile;
begin
  arquivo := ExtractFilePath(Application.ExeName) + 'Config.ini';
  FUrlBase := '';

  if not FileExists(arquivo) then
  begin
    raise Exception.Create('Arquivo de configuração da API não encontrado em: ' + arquivo + '!');
  end
  else
  try
    try
      ini := TIniFile.Create(arquivo);

      endereco := ini.ReadString('Parametro','Endereco','');
      porta := ini.ReadString('Parametro','Porta','');
      FTimeOut := ini.ReadInteger('Parametro', 'TimeOut', 300);

    finally
      FreeAndNil(ini);
    end;

    if endereco = '' then
    begin
      raise Exception.Create('O endereço IP do servidor deve ser informado no arquivo de configuração, contate o suporte!');
    end
    else if porta = '' then
    begin
      raise Exception.Create('A porta do servidor deve ser informado no arquivo de configuração, contate o suporte!');
    end
    else
    begin
      FUrlBase := 'http://' + endereco + ':' + porta;
    end;

  except
  on E: Exception do
  begin
    raise Exception.Create('Erro ao carregar informações do arquivo de configurações: '+ e.Message + '!');
  end;
  end;
end;

procedure TConexao.Configurar;
var
  i: integer;
begin
  self.AtribuirUrl;

  FCliente.Accept := '*/*';
  FCliente.AcceptCharset := 'UTF-8';
  FCliente.AcceptEncoding := 'gzip, deflate, br';
  FCliente.AllowCookies := True;
  FCliente.Authenticator := nil;
  FCliente.AutoCreateParams := True;
  FCliente.BaseURL := FUrlCompleta;
  FCliente.ConnectTimeout := FTimeOut;
  FCliente.ContentType := 'Application/Json';
  FCliente.FallbackCharsetEncoding := 'utf-8';
  FCliente.HandleRedirects := True;
  FCliente.Params.Clear;
  FCliente.ProxyPassword := '';
  FCliente.ProxyPort := 0;
  FCliente.ProxyServer := '';
  FCliente.ProxyUsername := '';
  FCliente.RaiseExceptionOn500 := True;
  FCliente.ReadTimeout := FTimeOut;
  FCliente.UserAgent := 'Embarcadero RESTClient/1.0';
  FCliente.Params.AddHeader('token', SessaoLogadoToken);

  FRequest.Accept := 'Application/Json';
  FRequest.AcceptCharset := 'utf-8';
  FRequest.AcceptEncoding := 'gzip, deflate, br';
  FRequest.Client := FCliente;
  FRequest.ConnectTimeout := FTimeOut;
  FRequest.HandleRedirects := True;
  FRequest.Method := FMetodo;
  FRequest.Timeout := FTimeOut;
  FRequest.Resource := '';
  FRequest.ResourceSuffix := '';
  FRequest.SynchronizedEvents := True;

  if (FMetodo = rmPOST) or (FMetodo = rmPUT) then
  begin
    FRequest.AddBody(FBody);
  end;
end;

constructor TConexao.Create;
begin
  inherited;
  FCliente := TRESTClient.Create(nil);
  FRequest := TRESTRequest.Create(nil);
  FBody := TJSONObject.Create;

  self.Limpar;
  self.CarregarIP;
  self.Configurar;
end;

destructor TConexao.Destroy;
begin
  FCliente.Destroy;
  FRequest.Destroy;
  FBody.Destroy;
  inherited;
end;

procedure TConexao.Enviar;
begin
  self.Configurar;

  try
    FRequest.Execute;
  except
    on e: Exception do
    begin
      FErro := e.Message;
      raise Exception.Create('Erro ao enviar a requisição: ' + e.Message);
    end;
  end;

  FStatus := FRequest.Response.StatusCode;
  FResposta := FRequest.Response.Content;

  if (FErro = '') then
  begin
    TratarErro;
  end;
end;

procedure TConexao.Limpar;
begin
  FCliente.Params.Clear;
  FRequest.Params.Clear;
  FCliente.BaseURL := '';
  FUrlCompleta := '';
  FUrl := FUrlBase;
  FErro := '';
  FResposta := '';
  FTimeOut := 0;
  FStatus := 0;
  FreeAndNil(FBody);
  FBody := TJSONObject.Create;
end;

procedure TConexao.TratarErro;
var
  json: TJSONValue;
  jsonArray: TJSONArray;
  i: Integer;
  mensagem, codigo: string;
begin
  if not (FStatus in[200..202]) then
  begin
    json := converterJsonTextoJsonValue(FResposta);
    jsonArray := converterJsonValueJsonArray(json, 'Erros');

    if Assigned(jsonArray) then
    for i := 0 to jsonArray.Count - 1 do
    begin
      codigo := jsonArray[i].GetValue<string>('Codigo', '');
      mensagem := jsonArray[i].GetValue<string>('mensagem', '');

      if (mensagem <> '') then
      begin
        mensagem := codigo + ': ' + mensagem;
      end;

      if (FErro = '') then
      begin
        FErro := mensagem;
      end
      else
      begin
        FErro := #13#10+ mensagem;
      end;
    end;
  end;
end;

end.
