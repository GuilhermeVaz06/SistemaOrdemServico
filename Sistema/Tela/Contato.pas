unit Contato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFContato = class(TForm)
    Panel1: TPanel;
    DBMemo1: TDBMemo;
    Label22: TLabel;
    Painel: TPanel;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    CBAtivo: TDBCheckBox;
    Label1: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBEdit6: TDBEdit;
    Label6: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    DBDocumento: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    EDTNascimento: TDateTimePicker;
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBLookupComboBox1Exit(Sender: TObject);
    procedure DBDocumentoExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EDTNascimentoChange(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FContato: TFContato;

implementation

uses DMClienteFornecedor, UFuncao;

{$R *.dfm}

procedure TFContato.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFContato.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMClienteFornecedor.TContato.State = dsInsert) then
    begin
      resposta := FDMClienteFornecedor.cadastrarContato;
    end
    else if (FDMClienteFornecedor.TContato.State = dsEdit) then
    begin
      resposta := FDMClienteFornecedor.alterarContato;
    end;

    if (resposta) then
    begin
      FDMClienteFornecedor.TContato.Post;
      FDMClienteFornecedor.TContato.Append;
      FDMClienteFornecedor.TContatocodigoPessoa.Value := FDMClienteFornecedor.TClienteFornecedorcodigo.Value;
    end;
  end;
end;

procedure TFContato.DBDocumentoExit(Sender: TObject);
begin
  with FDMClienteFornecedor do
  begin
    if TContato.State in[dsInsert, dsEdit] then
    begin
      TContatodocumento.Value := Trim(soNumeros(TContatodocumento.Value));
    end;
  end;
end;

procedure TFContato.DBLookupComboBox1Exit(Sender: TObject);
begin
  with FDMClienteFornecedor do
  begin
    if TContato.State in[dsInsert, dsEdit] then
    begin
      TContatocodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
      TContatotipoDocumento.Value := QTipoDocumentodescricao.Value;
      TContatomascaraCararteres.Value := QTipoDocumentomascara.Value;
      DBDocumento.SetFocus;
    end;
  end;
end;

procedure TFContato.EDTNascimentoChange(Sender: TObject);
begin
  FDMClienteFornecedor.TContatodataNascimento.Value := DateToStr(EDTNascimento.Date);
end;

procedure TFContato.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMClienteFornecedor.TContato.State in[dsInsert, dsEdit] then
  begin
    FDMClienteFornecedor.TContato.Cancel;
  end;
end;

procedure TFContato.FormShow(Sender: TObject);
begin
  EDTNascimento.Date := StrToDate(FDMClienteFornecedor.TContatodataNascimento.Value);
end;

function TFContato.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMClienteFornecedor do
  begin
    if not (TContatocodigoTipoDocumento.Value > 0) then
    begin
      mensagem.Add('O documento deve ser selecionada!');
    end;
    if (Trim(soNumeros(TContatodocumento.Value)) = '') and (QTipoDocumentoqtdeCaracteres.Value > 0) then
    begin
      mensagem.Add('O Nº do Documento deve ser informado!');
    end
    else if (Length(Trim(soNumeros(TContatodocumento.Value))) <> QTipoDocumentoqtdeCaracteres.Value) then
    begin
      mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(QTipoDocumentoqtdeCaracteres.Value) +
                   ' caracteres validos!');
    end;

    if (TContatonome.Value = '') then
    begin
      mensagem.Add('O nome deve ser informado!');
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
