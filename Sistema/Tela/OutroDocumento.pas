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
    procedure EDTEmissaoChange(Sender: TObject);
    procedure EDTVencimentoChange(Sender: TObject);
    procedure BConfirmarClick(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FOutroDocumento: TFOutroDocumento;

implementation

uses DMClienteFornecedor, UFuncao;

{$R *.dfm}

procedure TFOutroDocumento.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMClienteFornecedor.TOutroDocumento.State = dsInsert) then
    begin
      resposta := FDMClienteFornecedor.cadastrarOutroDocumento;
    end
    else if (FDMClienteFornecedor.TOutroDocumento.State = dsEdit) then
    begin
      resposta := FDMClienteFornecedor.alterarOutroDocumento;
    end;

    if (resposta) then
    begin
      FDMClienteFornecedor.TOutroDocumento.Post;

    end;
  end;
end;

procedure TFOutroDocumento.EDTEmissaoChange(Sender: TObject);
begin
  FDMClienteFornecedor.TOutroDocumentodataEmissao.Value := EDTEmissao.Date;
end;

procedure TFOutroDocumento.EDTVencimentoChange(Sender: TObject);
begin
  FDMClienteFornecedor.TOutroDocumentodataVencimento.Value := EDTVencimento.Date;
end;

function TFOutroDocumento.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMClienteFornecedor.TOutroDocumentoTipoDocumento.Value = '') then
  begin
    mensagem.Add('O Documento deve ser selecionado!');
  end
  else if (Trim(soNumeros(FDMClienteFornecedor.TOutroDocumentoDocumento.Value)) = '') then
  begin
    mensagem.Add('O Nº do Documento deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMClienteFornecedor.TOutroDocumentoDocumento.Value))) <> FDMClienteFornecedor.QTipoDocumentoqtdeCaracteres.Value) then
  begin
    mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(FDMClienteFornecedor.QTipoDocumentoqtdeCaracteres.Value) +
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
