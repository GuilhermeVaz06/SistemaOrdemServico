unit OrdemServicoFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFOrdemServicoFuncionario = class(TForm)
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
    DBFuncao: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit4: TDBEdit;
    DBFuncionario: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    DBEdit5: TDBEdit;
    Label17: TLabel;
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBFuncaoDblClick(Sender: TObject);
    procedure DBFuncaoExit(Sender: TObject);
    procedure DBEdit1Exit(Sender: TObject);
    procedure DBFuncionarioDblClick(Sender: TObject);
    procedure DBFuncionarioExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FOrdemServicoFuncionario: TFOrdemServicoFuncionario;

implementation

uses DMOrdemServico, UFuncao, Funcao, DMFuncao, DMPessoa;

{$R *.dfm}

procedure TFOrdemServicoFuncionario.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFOrdemServicoFuncionario.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMOrdemServico.TFuncionario.State = dsInsert) then
    begin
      resposta := FDMOrdemServico.cadastrarFuncionario;
    end
    else if (FDMOrdemServico.TFuncionario.State = dsEdit) then
    begin
      resposta := FDMOrdemServico.alterarFuncionario;
    end;

    if (resposta) then
    begin
      FDMOrdemServico.TFuncionario.Post;
      FDMOrdemServico.TFuncionario.Append;
      FDMOrdemServico.TFuncionarioordem.Value := FDMOrdemServico.TOrdemServicocodigo.Value;
    end;
  end;
end;

procedure TFOrdemServicoFuncionario.DBEdit1Exit(Sender: TObject);
var
  valorHoraNormal: Double;
begin
  with FDMOrdemServico do
  begin
    valorHoraNormal := TFuncionariovalorHoraNormal.Value;
    TFuncionariovalorTotalNormal.Value := valorHoraNormal * TFuncionarioqtdeHoraNormal.Value;

    TFuncionariovalorHora50.Value := ((valorHoraNormal / 100) * 50) + valorHoraNormal;
    TFuncionariovalorHora100.Value := ((valorHoraNormal / 100) * 100) + valorHoraNormal;
    TFuncionariovalorHoraAdNoturno.Value := ((valorHoraNormal / 100) * 20) + valorHoraNormal;

    TFuncionariovalorTotal50.Value := TFuncionariovalorHora50.Value * TFuncionarioqtdeHora50.Value;
    TFuncionariovalorTotal100.Value := TFuncionariovalorHora100.Value * TFuncionarioqtdeHora100.Value;
    TFuncionariovalorTotalAdNoturno.Value := TFuncionariovalorHoraAdNoturno.Value * TFuncionarioqtdeHoraAdNoturno.Value;

    TFuncionariovalorTotal.Value := TFuncionariovalorTotalNormal.Value +
                                    TFuncionariovalorTotal50.Value +
                                    TFuncionariovalorTotal100.Value +
                                    TFuncionariovalorTotalAdNoturno.Value;
  end;
end;

procedure TFOrdemServicoFuncionario.DBFuncionarioDblClick(Sender: TObject);
begin
  UFuncao.abreTelaFuncionario(True);
  if (FDMPessoa.TPessoa.RecordCount > 0) then
  begin
    FDMOrdemServico.TFuncionariocodigoFuncionario.Value := FDMPessoa.TPessoacodigo.Value;
    DBFuncionarioExit(nil);
  end;
end;

procedure TFOrdemServicoFuncionario.DBFuncionarioExit(Sender: TObject);
begin
  if (FDMOrdemServico.TFuncionariocodigoFuncionario.Value > 0) then
  begin
    FDMPessoa.tipoCadastro := 'funcionario';
    FDMPessoa.consultarDados(FDMOrdemServico.TFuncionariocodigoFuncionario.Value);

    if (FDMPessoa.TPessoa.RecordCount > 0) then
    begin
      FDMOrdemServico.TFuncionariocodigoFuncionario.Value := FDMPessoa.TPessoacodigo.Value;
      FDMOrdemServico.TFuncionarionomeFuncionario.Value := FDMPessoa.TPessoanome.Value;
    end
    else
    begin
      DBFuncionarioDblClick(nil);
    end;
  end;
end;

procedure TFOrdemServicoFuncionario.DBFuncaoDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFFuncao, FFuncao);
    FFuncao.consulta := True;
    FFuncao.ShowModal;
  finally
    FDMOrdemServico.TFuncionariocodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
    FreeAndNil(FFuncao);
    DBFuncaoExit(nil);
  end;
end;

procedure TFOrdemServicoFuncionario.DBFuncaoExit(Sender: TObject);
begin
  if (FDMOrdemServico.TFuncionariocodigoFuncao.Value > 0) then
  begin
    FDMFuncao.consultarDados(FDMOrdemServico.TFuncionariocodigoFuncao.Value);

    if (FDMFuncao.TFuncao.RecordCount > 0) then
    begin
      FDMOrdemServico.TFuncionariocodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
      FDMOrdemServico.TFuncionariodescricao.Value := FDMFuncao.TFuncaodescricao.Value;
      FDMOrdemServico.TFuncionarioqtdeHoraNormal.Value := 1;
      FDMOrdemServico.TFuncionarioqtdeHora50.Value := 1;
      FDMOrdemServico.TFuncionarioqtdeHora100.Value := 1;
      FDMOrdemServico.TFuncionarioqtdeHoraAdNoturno.Value := 1;
      FDMOrdemServico.TFuncionariovalorHoraNormal.Value := FDMFuncao.TFuncaovalorHoraNormal.Value;
      DBEdit1Exit(nil);
    end
    else
    begin
      DBFuncaoDblClick(nil);
    end;
  end
  else
  begin
    DBFuncaoDblClick(nil);
  end;
end;

procedure TFOrdemServicoFuncionario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMOrdemServico.TFuncionario.State in[dsInsert, dsEdit] then
  begin
    FDMOrdemServico.TFuncionario.Cancel;
  end;
end;

function TFOrdemServicoFuncionario.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMOrdemServico do
  begin
    if not (TFuncionariocodigoFuncao.Value > 0) then
    begin
      mensagem.Add('A função deve ser selecionada!');
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
