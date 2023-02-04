unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, model.Connection;

type
  TFPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    EIP: TEdit;
    Label1: TLabel;
    EPorta: TEdit;
    Label2: TLabel;
    BIniciar: TSpeedButton;
    BParar: TSpeedButton;
    BReiniciar: TSpeedButton;
    BSair: TSpeedButton;
    PStatus: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ELog: TMemo;
    procedure BIniciarClick(Sender: TObject);
    procedure BPararClick(Sender: TObject);
    procedure BReiniciarClick(Sender: TObject);
    procedure BSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIP: string;
    FPorta: integer;

    function validarIP(ip: string): boolean;
    function validarPorta(porta: string): boolean;
    procedure ativar(sinal: boolean);
  public
    { Public declarations }
  end;

var
  FConexao: TConexao;
  FPrincipal: TFPrincipal;
  status: Boolean;

implementation

uses Horse, Horse.Jhonson, Controller.Pais, Controller.Estado, Controller.Cidade;

{$R *.dfm}

procedure TFPrincipal.ativar(sinal: boolean);
begin
  BIniciar.Enabled := not sinal;
  BSair.Enabled := not sinal;
  BReiniciar.Enabled := sinal;
  BParar.Enabled := sinal;
  status := sinal;
  EIP.Enabled := not sinal;
  EPorta.Enabled := not sinal;
end;

procedure TFPrincipal.BIniciarClick(Sender: TObject);
begin
  FIP := EIP.Text;

  if  (Trim(UpperCase(EIP.Text)) <> 'LOCALHOST')
  and (validarIP(EIP.Text) = False) then
  begin
    ShowMessage('O IP informado é invalido!');
  end
  else if (validarPorta(EPorta.Text) = False) then
  begin
    ShowMessage('A porta informada é invalida!');
  end
  else if not status then
  try
    ativar(true);

    FConexao := TConexao.Create;
    Controller.Pais.Registry;
    Controller.Estado.Registry;
    Controller.Cidade.Registry;

    if (Trim(UpperCase(EIP.Text)) = 'LOCALHOST') then
    begin
      FIP := '127.0.0.1';
    end;

    THorse.Listen(FPorta, FIP);
    THorse.Use(Jhonson());

    PStatus.Caption := 'Status: Iniciado';
    PStatus.Font.Color := clGreen;

    ELog.Lines.Clear;
    ELog.Lines.Add('----------------------------------------------------------------------------------');
    ELog.Lines.Add('Servidor iniciado em:' + DateToStr(Now()) + ' ' + TimeToStr(Now()));

  except
    on E: Exception do
    begin
      ativar(false);
      ShowMessage(e.Message);
      ELog.Lines.Add('Erro ao iniciar o servidor:' + e.Message);
    end;
  end
  else
  begin
    ShowMessage('O servidor ja está iniciado!');
  end;
end;

procedure TFPrincipal.BPararClick(Sender: TObject);
begin
  if status then
  try
    THorse.StopListen;
    ativar(false);

    FConexao.Destroy;
    Controller.Pais.destruirConexao;
    Controller.Estado.destruirConexao;
    Controller.Cidade.destruirConexao;

    PStatus.Caption := 'Status: Parado';
    PStatus.Font.Color := clRed;

    ELog.Lines.Add('Servidor parado em:' + DateToStr(Now()) + ' ' + TimeToStr(Now()));
    ELog.Lines.Add('----------------------------------------------------------------------------------');
  except
    on E: Exception do
    begin
      ativar(true);
      ShowMessage(e.Message);
      ELog.Lines.Add('Erro ao parar o servidor:' + e.Message);
    end;
  end
  else
  begin
    ShowMessage('O servidor ja está parado!');
  end;
end;

procedure TFPrincipal.BReiniciarClick(Sender: TObject);
begin
  if status then
  begin
    BPararClick(nil);
    BIniciarClick(nil);
  end
  else
  begin
    ShowMessage('O servidor não foi iniciado!');
  end;
end;

procedure TFPrincipal.BSairClick(Sender: TObject);
begin
  if not status then
  begin
    Close;
  end
  else
  begin
    ShowMessage('O servidor está rodando!');
  end;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  EIP.Text := '192.168.1.30';
  EPorta.Text := '9000';
  status := false;
  BReiniciar.Enabled := False;
  BParar.Enabled := False;
  BIniciarClick(nil);
end;

function TFPrincipal.validarPorta(porta: string): boolean;
begin
  try
    FPorta := StrToInt(porta);
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

function TFPrincipal.validarIP(ip: string): boolean;
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
