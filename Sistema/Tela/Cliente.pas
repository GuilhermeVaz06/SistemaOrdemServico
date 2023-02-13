unit Cliente;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows, Vcl.ComCtrls;

type
  TFCliente = class(TForm)
    Panel1: TPanel;
    PDados: TPanel;
    BFechar: TSpeedButton;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    BInativar: TSpeedButton;
    BAlterar: TSpeedButton;
    BCadastrar: TSpeedButton;
    DBNavigator1: TDBNavigator;
    PGrid: TPanel;
    Panel2: TPanel;
    CBMostrarInativo: TCheckBox;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    GDados: TDBGrid;
    CBAtivo: TDBCheckBox;
    Panel4: TPanel;
    ELocalizarDescricao: TEdit;
    Label10: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ECadastradoPor: TDBEdit;
    EAlteradoPor: TDBEdit;
    EDataCadastro: TDBEdit;
    EDataAlteracao: TDBEdit;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ECodigo: TDBEdit;
    DBDocumento: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    Label8: TLabel;
    DBEdit2: TDBEdit;
    Label9: TLabel;
    DBEdit3: TDBEdit;
    Label11: TLabel;
    DBEdit4: TDBEdit;
    Label12: TLabel;
    DBMemo1: TDBMemo;
    Label13: TLabel;
    PCDados: TPageControl;
    TBOutrosDocumentos: TTabSheet;
    TBEndereco: TTabSheet;
    TBContato: TTabSheet;
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
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure DBLookupComboBox1Exit(Sender: TObject);
    procedure DBDocumentoExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FCliente: TFCliente;

implementation

uses UFuncao, DMCliente;

{$R *.dfm}

procedure TFCliente.BAlterarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMCliente.TCliente.Edit;
  PCDados.ActivePage := TBOutrosDocumentos;
end;

procedure TFCliente.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMCliente.TCliente.Append;
  PCDados.ActivePage := TBOutrosDocumentos;
end;

procedure TFCliente.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMCliente.TCliente.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFCliente.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMCliente.TCliente.State = dsInsert) then
    begin
      resposta := FDMCliente.cadastrarCliente;
    end
    else if (FDMCliente.TCliente.State = dsEdit) then
    begin
      resposta := FDMCliente.alterarCliente;
    end;

    if (resposta) then
    begin
      FDMCliente.TCliente.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFCliente.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMCliente.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFCliente.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFCliente.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if (UsuarioAdmnistrador) and
     (confirmar('Realmente deseja inativar o cliente: ' + FDMCliente.TClientenomeFantasia.Value + '?')) then
  begin
    codigo := FDMCliente.TClientecodigo.Value;

    if (FDMCliente.inativarCliente) then
    begin
      FDMCliente.consultarDados(0);
      FDMCliente.TCliente.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFCliente.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFCliente.DBDocumentoExit(Sender: TObject);
begin
  FDMCliente.TClientedocumento.Value := Trim(soNumeros(FDMCliente.TClientedocumento.Value));
end;

procedure TFCliente.DBLookupComboBox1Click(Sender: TObject);
begin
  FDMCliente.TClientecodigoTipoDocumento.Value := FDMCliente.QTipoDocumentocodigo.Value;
  FDMCliente.TClientetipoDocumento.Value := FDMCliente.QTipoDocumentodescricao.Value;
  FDMCliente.TClienteqtdeCaracteres.Value := FDMCliente.QTipoDocumentoqtdeCaracteres.Value;
  FDMCliente.TClientemascaraCaracteres.Value := FDMCliente.QTipoDocumentomascara.Value;
end;

procedure TFCliente.DBLookupComboBox1Exit(Sender: TObject);
begin
  DBDocumento.SetFocus;
end;

procedure TFCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFCliente.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFCliente.FormShow(Sender: TObject);
begin
  FDMCliente.consultarTipoDocumento;
  BConsultarClick(nil);
end;

procedure TFCliente.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFCliente.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFCliente.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFCliente.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMCliente.TClienterazaoSocial.Value = '') then
  begin
    mensagem.Add('A Razão Social deve ser informada!');
  end
  else if (Length(Trim(FDMCliente.TClienterazaoSocial.Value)) <= 2) then
  begin
    mensagem.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
  end
  else if (Length(Trim(FDMCliente.TClienterazaoSocial.Value)) > 150) then
  begin
    mensagem.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
  end;

  if (FDMCliente.TClientenomeFantasia.Value = '') then
  begin
    mensagem.Add('O Nome fantasia deve ser informado!');
  end
  else if (Length(Trim(FDMCliente.TClientenomeFantasia.Value)) <= 2) then
  begin
    mensagem.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
  end
  else if (Length(Trim(FDMCliente.TClientenomeFantasia.Value)) > 150) then
  begin
    mensagem.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
  end;

  if (FDMCliente.TClientetipoDocumento.Value = '') then
  begin
    mensagem.Add('O Documento deve ser selecionado!');
  end
  else if (Trim(soNumeros(FDMCliente.TClientedocumento.Value)) = '') then
  begin
    mensagem.Add('O Nº do Documento deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMCliente.TClientedocumento.Value))) <> FDMCliente.TClienteqtdeCaracteres.Value) then
  begin
    mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(FDMCliente.TClienteqtdeCaracteres.Value) +
                 ' caracteres validos!');
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
