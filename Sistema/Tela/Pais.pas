unit Pais;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFPais = class(TForm)
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
    EPais: TDBEdit;
    Label3: TLabel;
    ECodigo: TDBEdit;
    ECodigoIbge: TDBEdit;
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
    ELocalizarCodigoIBGE: TEdit;
    Label9: TLabel;
    ELocalizarNome: TEdit;
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
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FPais: TFPais;

implementation

uses UFuncao, DMPais;

{$R *.dfm}

procedure TFPais.BAlterarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMPais.TPais.Edit;
end;

procedure TFPais.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMPais.TPais.Append;
end;

procedure TFPais.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMPais.TPais.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFPais.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;

  if (validarCampos) then
  begin
    if (FDMPais.TPais.State = dsInsert) then
    begin
      resposta := FDMPais.cadastrarPais;
    end
    else if (FDMPais.TPais.State = dsEdit) then
    begin
      resposta := FDMPais.alterarPais;
    end;

    if (resposta) then
    begin
      FDMPais.TPais.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFPais.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMPais.consultarDados();
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFPais.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFPais.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if (UsuarioAdmnistrador) and
     (confirmar('Realmente deseja inativar o registro: ' + FDMPais.TPaisnome.Value + '?')) then
  begin
    codigo := FDMPais.TPaiscodigo.Value;

    if (FDMPais.inativarPais) then
    begin
      FDMPais.consultarDados;
      FDMPais.TPais.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFPais.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFPais.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFPais.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFPais.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFPais.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFPais.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMPais.TPaisnome.Value = '') then
  begin
    mensagem.Add('O Nome do País deve ser informado!');
  end
  else if (Length(Trim(FDMPais.TPaisnome.Value)) <= 2) then
  begin
    mensagem.Add('O nome do País deve conter no minimo 3 caracteres validos!');
  end;

  if (Trim(FDMPais.TPaiscodigoIbge.Value) = '') then
  begin
    mensagem.Add('O codigo do IBGE deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMPais.TPaiscodigoIbge.Value))) <> 4) then
  begin
    mensagem.Add('O codigo do IBGE deve conter 4 caracteres numericos validos!');
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
