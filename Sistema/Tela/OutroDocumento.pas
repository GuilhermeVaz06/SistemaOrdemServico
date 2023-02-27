unit OutroDocumento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFOutroDocumento = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    DBDocumento: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    EDTEmissao: TDateTimePicker;
    Label1: TLabel;
    EDTVencimento: TDateTimePicker;
    Label4: TLabel;
    DBMemo1: TDBMemo;
    Label22: TLabel;
    Painel: TPanel;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    CBAtivo: TDBCheckBox;
    procedure EDTEmissaoChange(Sender: TObject);
    procedure EDTVencimentoChange(Sender: TObject);
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DBLookupComboBox1Exit(Sender: TObject);
    procedure DBDocumentoExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FOutroDocumento: TFOutroDocumento;

implementation

uses DMPessoa, UFuncao;

{$R *.dfm}

procedure TFOutroDocumento.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFOutroDocumento.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMPessoa.TOutroDocumento.State = dsInsert) then
    begin
      resposta := FDMPessoa.cadastrarOutroDocumento;
    end
    else if (FDMPessoa.TOutroDocumento.State = dsEdit) then
    begin
      resposta := FDMPessoa.alterarOutroDocumento;
    end;

    if (resposta) then
    begin
      FDMPessoa.TOutroDocumento.Post;
      FDMPessoa.TOutroDocumento.Append;
      FDMPessoa.TOutroDocumentocodigoPessoa.Value := FDMPessoa.TPessoacodigo.Value;
      FDMPessoa.TOutroDocumentodataEmissao.Value := DateToStr(Date);
      FDMPessoa.TOutroDocumentodataVencimento.Value := DateToStr(Date);
    end;
  end;
end;

procedure TFOutroDocumento.DBDocumentoExit(Sender: TObject);
begin
  with FDMPessoa do
  begin
    if TOutroDocumento.State in[dsInsert, dsEdit] then
    begin
      TOutroDocumentodocumento.Value := Trim(soNumeros(TOutroDocumentodocumento.Value));
    end;
  end;
end;

procedure TFOutroDocumento.DBLookupComboBox1Exit(Sender: TObject);
begin
  with FDMPessoa do
  begin
    if TOutroDocumento.State in[dsInsert, dsEdit] then
    begin
      TOutroDocumentocodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
      TOutroDocumentotipoDocumento.Value := QTipoDocumentodescricao.Value;
      TOutroDocumentomascaraCaracteres.Value := QTipoDocumentomascara.Value;
      DBDocumento.SetFocus;
    end;
  end;
end;

procedure TFOutroDocumento.EDTEmissaoChange(Sender: TObject);
begin
  FDMPessoa.TOutroDocumentodataEmissao.Value := DateToStr(EDTEmissao.Date);
end;

procedure TFOutroDocumento.EDTVencimentoChange(Sender: TObject);
begin
  FDMPessoa.TOutroDocumentodataVencimento.Value := DateToStr(EDTVencimento.Date);
end;

procedure TFOutroDocumento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMPessoa.TOutroDocumento.State in[dsInsert, dsEdit] then
  begin
    FDMPessoa.TOutroDocumento.Cancel;
  end;
end;

procedure TFOutroDocumento.FormShow(Sender: TObject);
begin
  EDTEmissao.DateTime := StrToDate(FDMPessoa.TOutroDocumentodataEmissao.Value);
  EDTVencimento.DateTime := StrToDate(FDMPessoa.TOutroDocumentodataVencimento.Value);
  EDTEmissaoChange(nil);
  EDTVencimentoChange(nil);
end;

function TFOutroDocumento.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMPessoa do
  begin
    if not (TOutroDocumentocodigoTipoDocumento.Value > 0) then
    begin
      mensagem.Add('O Documento deve ser selecionado!');
    end;

    if (Trim(soNumeros(TOutroDocumentoDocumento.Value)) = '') then
    begin
      mensagem.Add('O Nº do Documento deve ser informado!');
    end;

    if (Length(Trim(soNumeros(TOutroDocumentoDocumento.Value))) <> QTipoDocumentoqtdeCaracteres.Value) then
    begin
      mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(QTipoDocumentoqtdeCaracteres.Value) +
                   ' caracteres validos!');
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
