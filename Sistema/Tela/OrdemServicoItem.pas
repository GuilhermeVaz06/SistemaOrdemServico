unit OrdemServicoItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFOrdemServicoItem = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    DBDocumento: TDBEdit;
    Painel: TPanel;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    CBAtivo: TDBCheckBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEdit2Exit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FOrdemServicoItem: TFOrdemServicoItem;

implementation

uses DMOrdemServico, UFuncao;

{$R *.dfm}

procedure TFOrdemServicoItem.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFOrdemServicoItem.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMOrdemServico.TItem.State = dsInsert) then
    begin
      resposta := FDMOrdemServico.cadastrarItem;
    end
    else if (FDMOrdemServico.TItem.State = dsEdit) then
    begin
      resposta := FDMOrdemServico.alterarItem;
    end;

    if (resposta) then
    begin
      FDMOrdemServico.TItem.Post;
      FDMOrdemServico.TItem.Append;
      FDMOrdemServico.TItemordem.Value := FDMOrdemServico.TOrdemServicocodigo.Value;
    end;
  end;
end;

procedure TFOrdemServicoItem.DBEdit2Exit(Sender: TObject);
begin
  FDMOrdemServico.TItemvalorTotal.Value := FDMOrdemServico.TItemquantidade.Value *
                                           FDMOrdemServico.TItemvalorUnitario.Value;

  FDMOrdemServico.TItemvalorDesconto.Value := (FDMOrdemServico.TItemvalorTotal.Value / 100) *
                                               FDMOrdemServico.TItemdesconto.Value;

  FDMOrdemServico.TItemvalorFinal.Value := FDMOrdemServico.TItemvalorTotal.Value -
                                           FDMOrdemServico.TItemvalorDesconto.Value;
end;

procedure TFOrdemServicoItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMOrdemServico.TItem.State in[dsInsert, dsEdit] then
  begin
    FDMOrdemServico.TItem.Cancel;
  end;
end;

function TFOrdemServicoItem.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMOrdemServico do
  begin
    if not (TItemquantidade.Value > 0) then
    begin
      mensagem.Add('A quantidade deve ser informada!');
    end;

    if (TItemdesconto.Value > 100) then
    begin
      mensagem.Add('O desconto informado n�o pode ser maior que 100%!');
    end;

    if not (TItemvalorUnitario.Value > 0) then
    begin
      mensagem.Add('O valor untario deve ser informado!');
    end;

    if (Trim(TItemdescricao.Value) = '') then
    begin
      mensagem.Add('A descri��o deve ser informada!');
    end;
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
