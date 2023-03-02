unit UFuncao;

interface

uses Vcl.Forms, Vcl.Grids, Winapi.Windows, FireDAC.Comp.Client, REST.Client,
     System.SysUtils, Vcl.Dialogs, System.DateUtils, Vcl.DBCtrls, Vcl.ExtCtrls,
     Vcl.Buttons, System.UITypes, System.JSON, DataSet.Serialize, Vcl.DBGrids,
     Vcl.Graphics, System.IniFiles, Horse, System.Classes, System.Generics.Collections,
     Web.HTTPApp;

function validarIP(ip: string): boolean;
function JsonErro(codigo, descricao: string): TJSONObject;
function soNumeros(Valor: string): string;
function strToDoubleZero(valor: string): Double;
function strToIntZero(valor: string): Integer;
function zerosEsquerda(valor, zeros: Integer): string; overload;
function zerosEsquerda(valor: string; zeros: Integer): string; overload;
function informar(texto: string): string; overload;
function informar(valor: Double): string; overload;
function informar(valor: integer): string; overload;
function IntToStrSenaoZero(valor: Integer): string;
function doubleToStrSenaoZero(valor: Double): string;
function confirmar(mesagem: String): Boolean;
function strZero(valor: string): string;
function firstDayOfMoth(data: TDateTime): TDateTime;
function lastDayOfMoth(data: TDateTime): TDateTime;
function formatarValorMonetario(valor: Double): string;
function arredondar(valor: Double): string;
function removerCasaDecimal(valor: Double): Double;
function imprimirRequisicao(requisicao: THorseRequest): string;
function imprimirResposta(status: Integer; resposta: TJSONObject): string;
function metodoString(metodo: TMethodType): string;
function DataBD(data: tdate): string; overload;
function DataBD(data: string): string; overload;
procedure desativaBotoes(form: TForm);
procedure colorirGrid(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
function VirgulaPonto(valor: double): string; overload;
function VirgulaPonto(valor: string): string; overload;

implementation

function VirgulaPonto(valor: double): string;
begin
  if trim(FloatToStr(valor)) = '' then
  begin
    valor := 0;
  end;

  Result := StringReplace(FloatToStr(valor), ',', '.', [rfReplaceAll, rfIgnoreCase]);
end;

function VirgulaPonto(valor: string): string;
begin
  if trim(valor) = '' then
  begin
    valor := '0';
  end;

  if pos(',', valor) > 0 then
  begin
    valor := StringReplace(valor, '.', '', [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := StringReplace(valor, ',', '.', [rfReplaceAll, rfIgnoreCase]);
end;

function DataBD(data: tdate): string; overload;
begin
  Try
    data := DateOf(data);

    Result := QuotedStr(FormatDateTime('yyyy-mm-dd', data));

  except on E: exception do
    begin
      informar('Erro ao converter data: ' +  #13 + DateToStr(data) + #13 + e.Message);
    end;
  end;

end;

function DataBD(data: string): string; overload;
var
  dataConvertida : Tdate;
begin
  Try
    dataConvertida := StrToDate(data);
    Result := DataBD(dataConvertida);
  except on E: exception do
    begin
      informar('Erro ao converter data: ' +QuotedStr(data)+  #13 + e.Message);
    end;
  end;
end;

function metodoString(metodo: TMethodType): string;
begin
  case metodo of
    mtAny: Result := 'ANY';
    mtGet: Result := 'GET';
    mtPut: Result := 'PUT';
    mtPost: Result := 'POST';
    mtHead: Result := 'HEAD';
    mtDelete: Result := 'DELETE';
    mtPatch : Result := 'PATCH';
  end;
end;

function imprimirResposta(status: Integer; resposta: TJSONObject): string;
var
  JsonResposta: TJSONObject;
begin
  JsonResposta := TJSONObject.Create;
  JsonResposta.AddPair('Status', IntToStrSenaoZero(status));
  JsonResposta.AddPair('Body', (resposta.Clone as TJSONObject));

  Result := JsonResposta.ToJSON;
  FreeAndNil(JsonResposta);
end;

function imprimirRequisicao(requisicao: THorseRequest): string;
var
  resposta, respostaItem: TJSONObject;
  i: integer;
  itens: TArray<TPair<string, string>>;
  body: TJSONValue;
begin
  resposta := TJSONObject.Create;

  resposta.AddPair('Type', metodoString(requisicao.MethodType));

  try
    if (requisicao.MethodType = mtPut) or (requisicao.MethodType = mtPost) then
    begin
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(requisicao.Body), 0) as TJSONValue;
      resposta.AddPair('Body', body);
    end;
  except
//  nao faz nada, isso foi feito so para nao travar o processamento
  end;

  if (requisicao.Headers.Count > 0) then
  begin
    respostaItem :=  TJSONObject.Create;
    itens := requisicao.Headers.ToArray;

    for i := 0 to Length(itens) - 1 do
    begin
      respostaItem.AddPair(itens[i].Key, itens[i].Value);
    end;

    resposta.AddPair('Headers', respostaItem);
  end;

  if (requisicao.Query.Count > 0) then
  begin
    respostaItem :=  TJSONObject.Create;
    itens := requisicao.Query.ToArray;

    for i := 0 to Length(itens) - 1 do
    begin
      respostaItem.AddPair(itens[i].Key, itens[i].Value);
    end;

    resposta.AddPair('QueryParms', respostaItem);
  end;

  if (requisicao.Params.Count > 0) then
  begin
    respostaItem :=  TJSONObject.Create;
    itens := requisicao.Params.ToArray;

    for i := 0 to Length(itens) - 1 do
    begin
      respostaItem.AddPair(itens[i].Key, itens[i].Value);
    end;

    resposta.AddPair('Parms', respostaItem);
  end;


  Result := resposta.ToJSON;
  FreeAndNil(resposta);
end;

procedure colorirGrid(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if ((Sender as TDBGrid).DataSource.DataSet.RecNo mod 2) = 0 then
  begin
    (Sender as TDBGrid).Canvas.Brush.Color := clActiveCaption;
    (Sender as TDBGrid).Canvas.Font.Color := clBlack;
  end
  else
  begin
    (Sender as TDBGrid).Canvas.Brush.Color := clWhite;
    (Sender as TDBGrid).Canvas.Font.Color := clBlack;
  end;

  if (gdSelected in State) then
  begin
    (Sender as TDBGrid).Canvas.Font.Style := (Sender as TDBGrid).Canvas.Font.Style + [fsbold];
    (Sender as TDBGrid).Canvas.Font.Size := (Sender as TDBGrid).Canvas.Font.Size + 1;
    (Sender as TDBGrid).Canvas.Brush.Color := clHighlight;
    (Sender as TDBGrid).Canvas.Font.Color := clHighlightText;
  end;

  (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

function arredondar(valor: Double): string;
begin
    Result := FormatFloat('#0.00', valor);
end;

function removerCasaDecimal(valor: Double): Double;
begin
  Result := StrToFloat(arredondar(valor));
end;

function formatarValorMonetario(valor: Double): string;
begin
  if (FloatToStr(valor) = '') then
  begin
    valor := 0;
  end;

  Result := FormatFloat('R$ #,0.00', valor);
end;

function strZero(valor: string): string;
begin
  if (valor = '') then
  begin
    Result := '0';
  end
  else
  begin
    Result := valor;
  end;
end;

function soNumeros(Valor: string): string;
var
  i: integer;
  Caracter, XValor: string;
begin
  i := 1;
  XValor := '';
  while i < (Length(Valor) + 1) do
  begin
    Caracter := Copy(Valor, i, 1);
    if (Caracter = '1') or
       (Caracter = '2') or
       (Caracter = '3') or
       (Caracter = '4') or
       (Caracter = '5') or
       (Caracter = '6') or
       (Caracter = '7') or
       (Caracter = '8') or
       (Caracter = '9') or
       (Caracter = '0') then
    begin
      XValor := XValor + Caracter;
    end;

    Inc(i);
  end;
  Result := XValor;
end;

function zerosEsquerda(valor, zeros: Integer): string; overload;
begin
  result := zerosEsquerda(IntToStrSenaoZero(valor), zeros);
end;

function zerosEsquerda(valor: string;zeros: Integer): string; overload;
var
  texto: string;
  i: Integer;
begin
  if (Length(valor) >= zeros) then
  begin
    result := valor;
  end
  else
  begin
    for i := 0 to (zeros - (Length(valor))) - 1 do
    begin
      texto := texto + '0';
    end;

    result := texto + valor;
  end;
end;

function doubleToStrSenaoZero(valor: Double): string;
var
  resultado: string;
begin
  resultado := FloatToStr(valor);
  if (resultado = '') then
  begin
    Result := '0';
  end
  else
  begin
    Result := resultado;
  end;
end;

function informar(texto: string): string; overload;
begin
  ShowMessage(texto);
end;

function informar(valor: Double): string; overload;
begin
  ShowMessage(doubleToStrSenaoZero(valor));
end;

function informar(valor: integer): string; overload;
begin
  ShowMessage(IntToStrSenaoZero(valor));
end;

function lastDayOfMoth(data: TDateTime): TDateTime;
begin
  if (DayOf(data) = 1) then
  begin
    data := IncDay(data,1);
  end;

  while DayOf(data) <> 1 do
  begin
    data := IncDay(data,1);
  end;
  data := IncDay(data,-1);
  Result := data;
end;

function firstDayOfMoth(data: TDateTime): TDateTime;
begin
  while DayOf(data) <> 1 do
  begin
    data := IncDay(data,-1);
  end;
  Result := data;
end;

function confirmar(mesagem: String): Boolean;
begin
  if (messagedlg(mesagem,mtconfirmation,mbokcancel,0) = 1) then
  begin
    Result := true;
  end
  else
  begin
    Result := False;
  end;
end;

function strToIntZero(valor: string): Integer;
var
  resultado: integer;
begin
  if (TryStrToInt(valor,resultado)) then
  begin
    result := resultado;
  end
  else
  begin
    result := 0;
  end;
end;

function strToDoubleZero(valor: string): Double;
var
  resultado: Double;
begin
  if (TryStrToFloat(valor,resultado)) then
  begin
    result := resultado;
  end
  else
  begin
    result := 0;
  end;
end;

function IntToStrSenaoZero(valor: Integer): string;
var
  resultado: string;
begin
  resultado := IntToStr(valor);
  if (resultado = '') then
  begin
    Result := '0';
  end
  else
  begin
    Result := resultado;
  end;
end;

procedure desativaBotoes(form: TForm);
var
  i: Integer;
begin
   for i := 0 to form.ComponentCount - 1 do
   begin
    if (form.Components[i] is TBitBtn) then
    begin
      (form.Components[i] as TBitBtn).Enabled := not (form.Components[i] as TBitBtn).Enabled;
    end
    else if (form.Components[i] is TSpeedButton) then
    begin
      (form.Components[i] as TSpeedButton).Enabled := not (form.Components[i] as TSpeedButton).Enabled;
    end
    else if (form.Components[i] is TPanel) then
    begin
      if (((form.Components[i] as TPanel).Name = 'PGrid') or ((form.Components[i] as TPanel).Name = 'PDados')) then
      begin
        (form.Components[i] as TPanel).Enabled := not (form.Components[i] as TPanel).Enabled;
      end;
    end
    else if (form.Components[i] is TDBNavigator) then
    begin
      (form.Components[i] as TDBNavigator).Enabled := not (form.Components[i] as TDBNavigator).Enabled;
    end;

   end;
end;

function JsonErro(codigo, descricao: string): TJSONObject;
var
  temporario: TJSONObject;
begin
  temporario := TJSONObject.Create;
  temporario.AddPair('Codigo', codigo);
  temporario.AddPair('mensagem',descricao);
  Result := temporario;
end;

function validarIP(ip: string): boolean;
var
  z:integer;
  i: byte;
  st: array[1..3] of byte;
  const
  ziff = ['0'..'9'];
begin
  st[1] := 0;
  st[2] := 0;
  st[3] := 0;
  z := 0;

  Result := true;
  for i := 1 to Length(ip) do
  begin
    if ip[i] in ziff then
    begin
//
    end
    else
    begin
      if ip[i] = '.' then
      begin
        Inc(z);
        if z < 4 then
        begin
          st[z] := i;
        end
        else
        begin
          Result := False;
          Exit;
        end;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  end;


  if (z <> 3)
  or (st[1] < 2)
  or (st[3] = Length(ip))
  or (st[1] + 2 > st[2])
  or (st[2] + 2 > st[3])
  or (st[1] > 4)
  or (st[2] > st[1] + 4)
  or (st[3] > st[2] + 4) then
  begin
    Result := False;
    Exit;
  end;

  z := StrToInt(Copy(ip, 1, st[1] - 1));

  if (z > 255)
  or (ip[1] = '0') then
  begin
    Result := False;
    Exit;
  end;

  z := StrToInt(Copy(ip, st[1] + 1, st[2] - st[1] - 1));

  if (z > 255)
  or ((z <> 0)
  and (ip[st[1] + 1] = '0')) then
  begin
    Result := False;
    Exit;
  end;

  z := StrToInt(Copy(ip, st[2] + 1, st[3] - st[2] - 1));

  if (z > 255)
  or ((z <> 0)
  and (ip[st[2] + 1] = '0')) then
  begin
    Result := False;
    Exit;
  end;

  z := StrToInt(Copy(ip, st[3] + 1, Length(ip) - st[3]));

  if (z > 255)
  or ((z <> 0)
  and (ip[st[3] + 1] = '0')) then
  begin
    Result := False;
    Exit;
  end;
end;

end.
