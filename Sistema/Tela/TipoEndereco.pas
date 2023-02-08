unit TipoEndereco;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFTipoEndereco = class(TForm)
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
  FTipoEndereco: TFTipoEndereco;

implementation

uses UFuncao, DMTipoEndereco;

{$R *.dfm}

procedure TFTipoEndereco.BAlterarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMTipoEndereco.TTipoEndereco.Edit;
end;

procedure TFTipoEndereco.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMTipoEndereco.TTipoEndereco.Append;
end;

procedure TFTipoEndereco.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMTipoEndereco.TTipoEndereco.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFTipoEndereco.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMTipoEndereco.TTipoEndereco.State = dsInsert) then
    begin
      resposta := FDMTipoEndereco.cadastrarTipoEndereco;
    end
    else if (FDMTipoEndereco.TTipoEndereco.State = dsEdit) then
    begin
      resposta := FDMTipoEndereco.alterarTipoEndereco;
    end;

    if (resposta) then
    begin
      FDMTipoEndereco.TTipoEndereco.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFTipoEndereco.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMTipoEndereco.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFTipoEndereco.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFTipoEndereco.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if (UsuarioAdmnistrador) and
     (confirmar('Realmente deseja inativar o registro: ' + FDMTipoEndereco.TTipoEnderecodescricao.Value + '?')) then
  begin
    codigo := FDMTipoEndereco.TTipoEnderecocodigo.Value;

    if (FDMTipoEndereco.inativarTipoEndereco) then
    begin
      FDMTipoEndereco.consultarDados(0);
      FDMTipoEndereco.TTipoEndereco.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFTipoEndereco.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFTipoEndereco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFTipoEndereco.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFTipoEndereco.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFTipoEndereco.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFTipoEndereco.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFTipoEndereco.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFTipoEndereco.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMTipoEndereco.TTipoEnderecodescricao.Value = '') then
  begin
    mensagem.Add('A descrição deve ser informada!');
  end
  else if (Length(Trim(FDMTipoEndereco.TTipoEnderecodescricao.Value)) <= 2) then
  begin
    mensagem.Add('A descrição deve conter no minimo 3 caracteres validos!');
  end
  else if (Length(Trim(FDMTipoEndereco.TTipoEnderecodescricao.Value)) > 150) then
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
