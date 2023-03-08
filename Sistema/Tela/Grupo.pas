unit Grupo;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFGrupo = class(TForm)
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
  FGrupo: TFGrupo;

implementation

uses UFuncao, DMGrupo;

{$R *.dfm}

procedure TFGrupo.BAlterarClick(Sender: TObject);
begin
  if not (FDMGrupo.TGrupo.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    FDMGrupo.TGrupo.Edit;
  end;
end;

procedure TFGrupo.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMGrupo.TGrupo.Append;
end;

procedure TFGrupo.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMGrupo.TGrupo.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFGrupo.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMGrupo.TGrupo.State = dsInsert) then
    begin
      resposta := FDMGrupo.cadastrarGrupo;
    end
    else if (FDMGrupo.TGrupo.State = dsEdit) then
    begin
      resposta := FDMGrupo.alterarGrupo;
    end;

    if (resposta) then
    begin
      FDMGrupo.TGrupo.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFGrupo.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMGrupo.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFGrupo.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFGrupo.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if not (FDMGrupo.TGrupo.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (UsuarioAdmnistrador) and
          (confirmar('Realmente deseja inativar o registro: ' + FDMGrupo.TGrupodescricao.Value + '?')) then
  begin
    codigo := FDMGrupo.TGrupocodigo.Value;

    if (FDMGrupo.inativarGrupo) then
    begin
      FDMGrupo.consultarDados(0);
      FDMGrupo.TGrupo.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFGrupo.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFGrupo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFGrupo.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFGrupo.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFGrupo.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFGrupo.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFGrupo.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFGrupo.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMGrupo.TGrupodescricao.Value = '') then
  begin
    mensagem.Add('A descrição deve ser informada!');
  end
  else if (Length(Trim(FDMGrupo.TGrupodescricao.Value)) <= 2) then
  begin
    mensagem.Add('A descrição deve conter no minimo 3 caracteres validos!');
  end
  else if (Length(Trim(FDMGrupo.TGrupodescricao.Value)) > 150) then
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
