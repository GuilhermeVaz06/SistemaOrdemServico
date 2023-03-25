unit OrdemServicoCusto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFOrdemServicoCusto = class(TForm)
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
    DBGrupo: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBEdit2Exit(Sender: TObject);
    procedure DBGrupoDblClick(Sender: TObject);
    procedure DBGrupoExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FOrdemServicoCusto: TFOrdemServicoCusto;

implementation

uses DMOrdemServico, UFuncao, Grupo, DMGrupo;

{$R *.dfm}

procedure TFOrdemServicoCusto.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFOrdemServicoCusto.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMOrdemServico.TCusto.State = dsInsert) then
    begin
      resposta := FDMOrdemServico.cadastrarCusto;
    end
    else if (FDMOrdemServico.TCusto.State = dsEdit) then
    begin
      resposta := FDMOrdemServico.alterarCusto;
    end;

    if (resposta) then
    begin
      FDMOrdemServico.TCusto.Post;
      FDMOrdemServico.TCusto.Append;
      FDMOrdemServico.TCustoordem.Value := FDMOrdemServico.TOrdemServicocodigo.Value;
    end;
  end;
end;

procedure TFOrdemServicoCusto.DBEdit2Exit(Sender: TObject);
begin
  FDMOrdemServico.TCustovalorTotal.Value := FDMOrdemServico.TCustoquantidade.Value *
                                           FDMOrdemServico.TCustovalorUnitario.Value;
end;

procedure TFOrdemServicoCusto.DBGrupoDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFGrupo, FGrupo);
    FGrupo.consulta := True;
    FGrupo.ShowModal;
  finally
    FDMOrdemServico.TCustocodigoGrupo.Value := FDMGrupo.TGrupocodigo.Value;
    FreeAndNil(FGrupo);
    DBGrupoExit(nil);
  end;
end;

procedure TFOrdemServicoCusto.DBGrupoExit(Sender: TObject);
begin
  if (FDMOrdemServico.TCustocodigoGrupo.Value > 0) then
  begin
    FDMGrupo.consultarDados(FDMOrdemServico.TCustocodigoGrupo.Value);

    if (FDMGrupo.TGrupo.RecordCount > 0) then
    begin
      FDMOrdemServico.TCustocodigoGrupo.Value := FDMGrupo.TGrupocodigo.Value;
      FDMOrdemServico.TCustodescricao.Value := FDMGrupo.TGrupodescricao.Value;
      FDMOrdemServico.TCustosubDescricao.Value := FDMGrupo.TGruposubDescricao.Value;
      FDMOrdemServico.TCustoquantidade.Value := 1;
      FDMOrdemServico.TCustovalorUnitario.Value := FDMGrupo.TGrupovalor.Value;
      DBEdit2Exit(nil);
    end
    else
    begin
      DBGrupoDblClick(nil);
    end;
  end
  else
  begin
    DBGrupoDblClick(nil);
  end;
end;

procedure TFOrdemServicoCusto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMOrdemServico.TCusto.State in[dsInsert, dsEdit] then
  begin
    FDMOrdemServico.TCusto.Cancel;
  end;
end;

function TFOrdemServicoCusto.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMOrdemServico do
  begin
    if not (TCustocodigoGrupo.Value > 0) then
    begin
      mensagem.Add('O grupo deve ser selecionado!');
    end;

    if not (TCustoquantidade.Value > 0) then
    begin
      mensagem.Add('A quantidade deve ser informada!');
    end;

    if not (TCustovalorUnitario.Value > 0) then
    begin
      mensagem.Add('O valor untario deve ser informado!');
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
