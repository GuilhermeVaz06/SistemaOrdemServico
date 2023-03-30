unit UFuncao;

interface

uses Vcl.Forms, Vcl.Grids, Winapi.Windows, FireDAC.Comp.Client, REST.Client,
     System.SysUtils, Vcl.Dialogs, System.DateUtils, Vcl.DBCtrls, Vcl.ExtCtrls,
     Vcl.Buttons, System.UITypes, System.JSON, DataSet.Serialize, Vcl.DBGrids,
     Vcl.Graphics, System.IniFiles, REST.Response.Adapter, Data.DBJson,
     Vcl.StdCtrls, Vcl.ComCtrls, System.MaskUtils, IdHashMessageDigest;

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
function mascaraTelefone(telefone: string): string;
function firstDayOfMoth(data: TDateTime): TDateTime;
function lastDayOfMoth(data: TDateTime): TDateTime;
function formatarValorMonetario(valor: Double): string;
function arredondar(valor: Double): string;
function removerCasaDecimal(valor: Double): Double;
function converterJsonArrayRestResponse(json: TJSONArray): IRESTResponseJSON;
function converterJsonTextoJsonValue(jsonText: string): TJSONValue;
function converterJsonValueJsonArray(json: TJSONValue; nome: string): TJSONArray;
function VirgulaPonto(valor: double): string; overload;
function VirgulaPonto(valor: string): string; overload;
function PontoVirgula(valor: string): Double;
function criarToken(token: string): string;
procedure desativaBotoes(form: TForm);
procedure abreTelaCliente(consulta: Boolean);
procedure abreTelaEmpresa(consulta: Boolean);
procedure abreTelaFornecedor(consulta: Boolean);
procedure abreTelaUsuario(consulta: Boolean);
procedure abreTelaFuncionario(consulta: Boolean);
procedure ordenarGrid(Coluna: TColumn);
procedure copiarItemJsonArray(arrayOrigem: TJSONArray; out arrayDestino : TJSONArray);
procedure converterArrayJsonQuery(json: IRESTResponseJSON; out dataSet: TFDMemTable); overload;
procedure converterArrayJsonQuery(json: string; out dataSet: TFDMemTable); overload;
procedure limparCampoLookUp(sender: TObject; Key: Word);
procedure colorirGrid(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);

var
  NomeUsuarioSessaoLogado: string;
  UsuarioAdmnistrador: Boolean;
  SessaoLogadoToken: string;

implementation

uses Pessoa, DMPessoa;

procedure limparCampoLookUp(sender: TObject; Key: Word);
begin
  if (sender is TDBLookupComboBox) then
  begin
    if (Key = vk_back) or
       (Key = vk_delete) then
    begin
      (Sender as TDBLookupComboBox).KeyValue := -1;
    end;
  end;
end;

function VirgulaPonto(valor: double): string;
begin
  if trim(FloatToStr(valor)) = '' then
  begin
    valor := 0;
  end;

  Result := StringReplace(FloatToStr(valor), ',', '.', [rfReplaceAll, rfIgnoreCase]);
end;

function PontoVirgula(valor: string): Double;
begin
  if trim(valor) = '' then
  begin
    valor := '0';
  end;

  if pos('.', valor) > 0 then
  begin
    valor := StringReplace(valor, '.', ',', [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := strToDoubleZero(valor);
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

function mascaraTelefone(telefone: string): string;
begin
  if (Length(telefone) = 12) then
  begin
    Result := FormatMaskText('(999) 9 9999-9999;0', telefone);
  end
  else if (Length(telefone) = 11) then
  begin
    Result := FormatMaskText('(99) 9 9999-9999;0', telefone);
  end
  else if (Length(telefone) = 10) then
  begin
    Result := FormatMaskText('(99) 9999-9999;0', telefone);
  end
  else if (Length(telefone) = 9) then
  begin
    Result := FormatMaskText('9 9999-9999;0', telefone);
  end
  else if (Length(telefone) = 8) then
  begin
    Result := FormatMaskText('9999-9999;0', telefone);
  end
  else
  begin
    Result := telefone;
  end;
end;

procedure abreTelaCliente(consulta: Boolean);
begin
  try
    Application.CreateForm(TFPessoa, FPessoa);
    FPessoa.Caption := 'Cadastro de Cliente';
    FPessoa.consulta := consulta;
    FDMPessoa.tipoCadastro := 'cliente';
    FPessoa.PFuncao.Visible := False;
    FPessoa.ShowModal;
  finally
    FreeAndNil(FPessoa);
  end;
end;

procedure abreTelaEmpresa(consulta: Boolean);
begin
  try
    Application.CreateForm(TFPessoa, FPessoa);
    FPessoa.Caption := 'Cadastro de Empresa Faturamento';
    FPessoa.consulta := consulta;
    FDMPessoa.tipoCadastro := 'empresa';
    FPessoa.PFuncao.Visible := False;
    FPessoa.ShowModal;
  finally
    FreeAndNil(FPessoa);
  end;
end;

procedure abreTelaFornecedor(consulta: Boolean);
begin
  try
    Application.CreateForm(TFPessoa, FPessoa);
    FPessoa.Caption := 'Cadastro de Fornecedor';
    FPessoa.consulta := consulta;
    FDMPessoa.tipoCadastro := 'fornecedor';
    FPessoa.PFuncao.Visible := False;
    FPessoa.ShowModal;
  finally
    FreeAndNil(FPessoa);
  end;
end;

procedure abreTelaFuncionario(consulta: Boolean);
begin
  try
    Application.CreateForm(TFPessoa, FPessoa);
    FPessoa.Caption := 'Cadastro de Funcionario';
    FPessoa.consulta := consulta;
    FPessoa.PFuncao.Visible := True;
    FPessoa.DBLDocumento.Enabled := False;
    FPessoa.LRazaoSocial.Caption := 'Nome';
    FPessoa.DBRazaoSocial.DataField := 'nome';
    FPessoa.LConsultaRazaoSocial.Caption := 'Nome';
    FPessoa.DBRazaoSocial.Width := 374;
    FPessoa.LNomeFantasia.Visible := False;
    FPessoa.DBNomeFantasia.Visible := False;
    FPessoa.TBOutrosDocumentos.TabVisible := False;
    FPessoa.TBContato.TabVisible := False;
    FPessoa.LConsultaNomeFantasia.Visible := False;
    FPessoa.ENomeFantasia.Visible := False;
    FPessoa.ERazaoSocial.Width := 374;
    FDMPessoa.tipoCadastro := 'funcionario';
    FPessoa.ShowModal;
  finally
    FreeAndNil(FPessoa);
  end;
end;

procedure abreTelaUsuario(consulta: Boolean);
begin
  try
    Application.CreateForm(TFPessoa, FPessoa);
    FPessoa.Caption := 'Cadastro de Usuario';
    FPessoa.consulta := consulta;
    FPessoa.PFuncao.Visible := False;
    FPessoa.DBLDocumento.Enabled := False;
    FPessoa.LRazaoSocial.Caption := 'Nome';
    FPessoa.DBRazaoSocial.DataField := 'nome';
    FPessoa.LConsultaRazaoSocial.Caption := 'Nome';
    FPessoa.LNomeFantasia.Caption := 'Senha';
    FPessoa.DBNomeFantasia.DataField := 'senha';
    FPessoa.DBNomeFantasia.PasswordChar := '*';
    FPessoa.TBOutrosDocumentos.TabVisible := False;
    FPessoa.TBContato.TabVisible := False;
    FPessoa.LConsultaNomeFantasia.Visible := False;
    FPessoa.ENomeFantasia.Visible := False;
    FPessoa.ERazaoSocial.Width := 374;
    FDMPessoa.tipoCadastro := 'usuario';
    FPessoa.ShowModal;
  finally
    FreeAndNil(FPessoa);
  end;
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
    else if (form.Components[i] is TTabSheet) then
    begin
      if ((form.Components[i] as TTabSheet).Parent.Name = 'PCTela') then
      begin
        if ((form.Components[i] as TTabSheet).Name <> 'TBCadastro') then
        begin
          (form.Components[i] as TTabSheet).TabVisible := not (form.Components[i] as TTabSheet).TabVisible;
        end;
      end;
    end
    else if (form.Components[i] is TPanel) then
    begin
      if ((form.Components[i] as TPanel).Name = 'PGrid') or
         ((form.Components[i] as TPanel).Name = 'PDados') or
         ((form.Components[i] as TPanel).Name = 'PInfo') then
      begin
        (form.Components[i] as TPanel).Enabled := not (form.Components[i] as TPanel).Enabled;
      end;
    end
    else if (form.Components[i] is TDBCheckBox) then
    begin
      (form.Components[i] as TDBCheckBox).Enabled := not (form.Components[i] as TDBCheckBox).Enabled;
    end
    else if (form.Components[i] is TCheckBox) then
    begin
      (form.Components[i] as TCheckBox).Enabled := not (form.Components[i] as TCheckBox).Enabled;
    end
    else if (form.Components[i] is TDBGrid) then
    begin
      (form.Components[i] as TDBGrid).Enabled := not (form.Components[i] as TDBGrid).Enabled;
    end
    else if (form.Components[i] is TDBNavigator) then
    begin
      (form.Components[i] as TDBNavigator).Enabled := not (form.Components[i] as TDBNavigator).Enabled;
    end;

   end;
end;

function converterJsonTextoJsonValue(jsonText: string): TJSONValue;
var
  json: TJSONValue;
begin
  json := TJSONObject.ParseJSONValue(jsonText, False, False);

  if Assigned(json) then
  begin
    Result := json;
  end
  else
  begin
    informar('Impossivel converter o texto em json, contate o suporte!');
    Result := nil;
  end;
end;

procedure converterArrayJsonQuery(json: string; out dataSet: TFDMemTable); overload;
var
  jsonConvertido: TJSONValue;
  jsonArray: TJSONArray;
begin
  jsonConvertido := converterJsonTextoJsonValue(json);
  jsonArray := converterJsonValueJsonArray(jsonConvertido, 'dados');

  if Assigned(jsonArray) then
  begin
    converterArrayJsonQuery(converterJsonArrayRestResponse(jsonArray), dataSet);
  end;
end;

function converterJsonArrayRestResponse(json: TJSONArray): IRESTResponseJSON;
begin
  if (Assigned(json)) then
  begin
    Result := TRESTResponseJSON.Create(nil, json, false);
  end
  else
  begin
    informar('Impossivel converter o Json Array em Response Json, contate o suporte!');
    Result := nil;
  end;
end;

function converterJsonValueJsonArray(json: TJSONValue; nome: string): TJSONArray;
var
  jsonArray: TJSONArray;
begin
  jsonArray := json.GetValue<TJSONArray>(nome, TJSONArray.Create);

  if Assigned(jsonArray) then
  begin
    Result := jsonArray;
  end
  else
  begin
    informar('Impossivel converter o json em json array, contate o suporte!');
    Result := nil;
  end;
end;

procedure converterArrayJsonQuery(json: IRESTResponseJSON; out dataSet: TFDMemTable); overload;
var
  FAdaptador: TRESTResponseDataSetAdapter;
begin
  if Assigned(dataSet) and (Assigned(json)) then
  begin
    FAdaptador := TRESTResponseDataSetAdapter.Create(nil);
    dataSet.Active := False;
    FAdaptador.Active := False;
    FAdaptador.Dataset := dataSet;
    FAdaptador.AutoUpdate := True;
    FAdaptador.MetaMergeMode := TJSONMetaMergeMode.Merge;
    FAdaptador.NestedElements := False;
    FAdaptador.NestedElementsDepth := 0;
    FAdaptador.ObjectView := False;
    FAdaptador.RootElement := '';
    FAdaptador.SampleObjects := 1;
    FAdaptador.StringFieldSize := 255;
    FAdaptador.Tag := 0;
    FAdaptador.TypesMode := TJSONTypesMode.StringOnly;
    FAdaptador.ResponseJSON := json;
    FAdaptador.Active := True;
    dataSet.Active := True;
    FAdaptador.Destroy;
  end;
end;

procedure copiarItemJsonArray(arrayOrigem: TJSONArray; out arrayDestino : TJSONArray);
var
  i: integer;
begin
  for i := 0 to arrayOrigem.Count - 1 do
  begin
    arrayDestino.Add((arrayOrigem[i] as TJSONObject));
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

procedure ordenarGrid(Coluna: TColumn);
var
  grid: TCustomDBGrid;
  indiceanterior: string;
begin
  grid := Coluna.Grid;

  if grid.DataSource.DataSet is TFDMemTable then
  begin
    if (TFDMemTable(grid.DataSource.DataSet).IndexFieldNames <> Coluna.FieldName + ':A ') then
    begin
      TFDMemTable(grid.DataSource.DataSet).IndexFieldNames := indiceanterior + Coluna.FieldName + ':A ';
    end
    else
    begin
      TFDMemTable(grid.DataSource.DataSet).IndexFieldNames := indiceanterior + Coluna.FieldName + ':D ';
    end;
  end;
end;

function criarToken(token: string): string;
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

end.
