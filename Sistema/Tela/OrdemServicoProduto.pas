unit OrdemServicoProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFOrdemServicoProduto = class(TForm)
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
    Label8: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
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
  FOrdemServicoProduto: TFOrdemServicoProduto;

implementation

uses DMOrdemServico, UFuncao;

{$R *.dfm}

procedure TFOrdemServicoProduto.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFOrdemServicoProduto.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMOrdemServico.TProduto.State = dsInsert) then
    begin
      resposta := FDMOrdemServico.cadastrarProduto;
    end
    else if (FDMOrdemServico.TProduto.State = dsEdit) then
    begin
      resposta := FDMOrdemServico.alterarProduto;
    end;

    if (resposta) then
    begin
      FDMOrdemServico.TProduto.Post;
      FDMOrdemServico.TProduto.Append;
      FDMOrdemServico.TProdutoordem.Value := FDMOrdemServico.TOrdemServicocodigo.Value;
    end;
  end;
end;

procedure TFOrdemServicoProduto.DBEdit2Exit(Sender: TObject);
begin
  FDMOrdemServico.TProdutovalorTotal.Value := FDMOrdemServico.TProdutoquantidade.Value *
                                           FDMOrdemServico.TProdutovalorUnitario.Value;

  FDMOrdemServico.TProdutovalorDesconto.Value := (FDMOrdemServico.TProdutovalorTotal.Value / 100) *
                                               FDMOrdemServico.TProdutodesconto.Value;

  FDMOrdemServico.TProdutovalorFinal.Value := FDMOrdemServico.TProdutovalorTotal.Value -
                                           FDMOrdemServico.TProdutovalorDesconto.Value;
end;

procedure TFOrdemServicoProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMOrdemServico.TProduto.State in[dsInsert, dsEdit] then
  begin
    FDMOrdemServico.TProduto.Cancel;
  end;
end;

function TFOrdemServicoProduto.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMOrdemServico do
  begin
    if not (TProdutoquantidade.Value > 0) then
    begin
      mensagem.Add('A quantidade deve ser informada!');
    end;

    if not (TProdutovalorUnitario.Value > 0) then
    begin
      mensagem.Add('O valor untario deve ser informado!');
    end;

    if (Trim(TProdutodescricao.Value) = '') then
    begin
      mensagem.Add('A descrição deve ser informada!');
    end;

    if (TProdutodesconto.Value > 100) then
    begin
      mensagem.Add('O desconto informado não pode ser maior que 100%!');
    end;

    if (Trim(TProdutounidade.Value) = '') then
    begin
      mensagem.Add('A unidade deve ser selecionada!');
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
