unit Funcao;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFFuncao = class(TForm)
    Panel1: TPanel;
    PDados: TPanel;
    BFechar: TSpeedButton;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    BInativar: TSpeedButton;
    BAlterar: TSpeedButton;
    BCadastrar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    ECodigo: TDBEdit;
    EDescricao: TDBEdit;
    DBNavigator1: TDBNavigator;
    PGrid: TPanel;
    Panel2: TPanel;
    CBMostrarInativo: TCheckBox;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    GDados: TDBGrid;
    CBAtivo: TDBCheckBox;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ECadastradoPor: TDBEdit;
    EAlteradoPor: TDBEdit;
    EDataCadastro: TDBEdit;
    EDataAlteracao: TDBEdit;
    ELocalizarDescricao: TEdit;
    Label10: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label11: TLabel;
    procedure BFecharClick(Sender: TObject);
    procedure BCadastrarClick(Sender: TObject);
    procedure BAlterarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure BConfirmarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure BConsultarClick(Sender: TObject);
    procedure BInativarClick(Sender: TObject);
    procedure GDadosTitleClick(Column: TColumn);
    procedure CBMostrarInativoClick(Sender: TObject);
    procedure GDadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FFuncao: TFFuncao;

implementation

uses UFuncao, DMFuncao;

{$R *.dfm}

procedure TFFuncao.BAlterarClick(Sender: TObject);
begin
  if not (FDMFuncao.TFuncao.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    FDMFuncao.TFuncao.Edit;
  end;
end;

procedure TFFuncao.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMFuncao.TFuncao.Append;
end;

procedure TFFuncao.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMFuncao.TFuncao.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFFuncao.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMFuncao.TFuncao.State = dsInsert) then
    begin
      resposta := FDMFuncao.cadastrarFuncao;
    end
    else if (FDMFuncao.TFuncao.State = dsEdit) then
    begin
      resposta := FDMFuncao.alterarFuncao;
    end;

    if (resposta) then
    begin
      FDMFuncao.TFuncao.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFFuncao.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMFuncao.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFFuncao.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFFuncao.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if not (FDMFuncao.TFuncao.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (UsuarioAdmnistrador) and
          (confirmar('Realmente deseja inativar o registro: ' + FDMFuncao.TFuncaodescricao.Value + '?')) then
  begin
    codigo := FDMFuncao.TFuncaocodigo.Value;

    if (FDMFuncao.inativarFuncao) then
    begin
      FDMFuncao.consultarDados(0);
      FDMFuncao.TFuncao.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFFuncao.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFFuncao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFFuncao.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFFuncao.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFFuncao.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFFuncao.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFFuncao.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFFuncao.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMFuncao.TFuncaodescricao.Value = '') then
  begin
    mensagem.Add('A descrição deve ser informada!');
  end
  else if (Length(Trim(FDMFuncao.TFuncaodescricao.Value)) <= 2) then
  begin
    mensagem.Add('A descrição deve conter no minimo 3 caracteres validos!');
  end
  else if (Length(Trim(FDMFuncao.TFuncaodescricao.Value)) > 150) then
  begin
    mensagem.Add('A descrição deve conter no maximo 150 caracteres validos!');
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
