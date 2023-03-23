unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  model.Connection, Horse, Horse.Jhonson, Vcl.Graphics;

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
    FStatus: Boolean;

    function validarPorta(porta: string): boolean;
    procedure ativar(sinal: boolean);
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;
  FConexao: TConexao;
  const tpCliente = 1;
  const tpFornecedor = 2;
  const tpFuncionario = 3;
  const tpUsuario = 4;
  const tpEmpresa = 5;

implementation

uses Controller.Pais, Controller.Estado, Controller.Cidade,
     Controller.TipoDocumento, Controller.TipoEndereco, UFuncao,
     Controller.Pessoa, Controller.Pessoa.OutroDocumento,
     Controller.Pessoa.Endereco, Controller.Pessoa.Contato,
     Controller.Funcao, Controller.Grupo, Controller.OrdemServico,
     Controller.OrdemServico.Item, Controller.OrdemServico.Produto;

{$R *.dfm}

procedure TFPrincipal.ativar(sinal: boolean);
begin
  BIniciar.Enabled := not sinal;
  BSair.Enabled := not sinal;
  BReiniciar.Enabled := sinal;
  BParar.Enabled := sinal;
  FStatus := sinal;
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
  else if not FStatus then
  try
    ativar(true);

    FConexao := TConexao.Create;
    Controller.Funcao.Registry;
    Controller.Pais.Registry;
    Controller.Estado.Registry;
    Controller.Cidade.Registry;
    Controller.TipoDocumento.Registry;
    Controller.TipoEndereco.Registry;
    Controller.pessoa.Registry;
    Controller.pessoa.OutroDocumento.Registry;
    Controller.pessoa.Endereco.Registry;
    Controller.pessoa.Contato.Registry;
    Controller.Grupo.Registry;
    Controller.OrdemServico.Registry;
    Controller.OrdemServico.Item.Registry;
    Controller.OrdemServico.Produto.Registry;

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
  if FStatus then
  try
    THorse.StopListen;
    ativar(false);

    FConexao.Destroy;
    Controller.Pais.destruirConexao;
    Controller.Estado.destruirConexao;
    Controller.Cidade.destruirConexao;
    Controller.TipoDocumento.destruirConexao;
    Controller.TipoEndereco.destruirConexao;
    Controller.pessoa.destruirConexao;
    Controller.pessoa.OutroDocumento.destruirConexao;
    Controller.pessoa.Endereco.destruirConexao;
    Controller.pessoa.Contato.destruirConexao;
    Controller.Funcao.destruirConexao;
    Controller.Grupo.destruirConexao;
    Controller.OrdemServico.destruirConexao;
    Controller.OrdemServico.Item.destruirConexao;
    Controller.OrdemServico.Produto.destruirConexao;

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
  if FStatus then
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
  if not FStatus then
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
  FStatus := false;
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

end.
