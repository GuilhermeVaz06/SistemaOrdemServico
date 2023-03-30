unit Senha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TFSenha = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    ESenha: TEdit;
    Panel2: TPanel;
    BEntrar: TSpeedButton;
    BSair: TSpeedButton;
    EUsuario: TEdit;
    procedure BSairClick(Sender: TObject);
    procedure BEntrarClick(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FSenha: TFSenha;

implementation

uses UFuncao, DMPessoa;

{$R *.dfm}

procedure TFSenha.BEntrarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  if (validarCampos) then
  begin
    resposta := FDMPessoa.logar(EUsuario.Text, UFuncao.criarToken(ESenha.Text));

    if (resposta) then
    begin
      FSenha.ModalResult := mrOk;
    end;
  end;
end;

procedure TFSenha.BSairClick(Sender: TObject);
begin
  FSenha.ModalResult := mrCancel;
end;

function TFSenha.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (EUsuario.Text = '') then
  begin
    mensagem.Add('O usuario deve ser informado!');
  end;

  if (ESenha.Text = '') then
  begin
    mensagem.Add('A senha deve ser informada!');
  end;

  if (mensagem.Text <> '') then
  begin
    informar(mensagem.Text);
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  FreeAndNil(mensagem);
end;

end.
