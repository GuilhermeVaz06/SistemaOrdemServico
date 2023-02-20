unit Endereco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, DB;

type
  TFEndereco = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    DBMemo1: TDBMemo;
    Label22: TLabel;
    Painel: TPanel;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    CBAtivo: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBEdit6: TDBEdit;
    Label6: TLabel;
    DBCidade: TDBEdit;
    Label7: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Label8: TLabel;
    DBEdit10: TDBEdit;
    Label9: TLabel;
    Label10: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    DBDescricao: TDBEdit;
    procedure BConfirmarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBDescricaoDblClick(Sender: TObject);
    procedure DBDescricaoExit(Sender: TObject);
    procedure DBCidadeExit(Sender: TObject);
    procedure DBCidadeDblClick(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
  end;

var
  FEndereco: TFEndereco;

implementation

uses DMClienteFornecedor, UFuncao, TipoEndereco, Cidade, DMTipoEndereco, DMCidade;

{$R *.dfm}

procedure TFEndereco.BCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFEndereco.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMClienteFornecedor.TEndereco.State = dsInsert) then
    begin
      resposta := FDMClienteFornecedor.cadastrarEndereco;
    end
    else if (FDMClienteFornecedor.TEndereco.State = dsEdit) then
    begin
      resposta := FDMClienteFornecedor.alterarEndereco;
    end;

    if (resposta) then
    begin
      FDMClienteFornecedor.TEndereco.Post;
      FDMClienteFornecedor.TEndereco.Append;
      FDMClienteFornecedor.TEnderecocodigoPessoa.Value := FDMClienteFornecedor.TClienteFornecedorcodigo.Value;
    end;
  end;
end;

procedure TFEndereco.DBDescricaoDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFTipoEndereco, FTipoEndereco);
    FTipoEndereco.consulta := True;
    FTipoEndereco.ShowModal;
  finally
    FDMClienteFornecedor.TEnderecocodigoTipoEndereco.Value := FDMTipoEndereco.TTipoEnderecocodigo.Value;
    FreeAndNil(FTipoEndereco);
    DBDescricaoExit(nil);
  end;
end;

procedure TFEndereco.DBDescricaoExit(Sender: TObject);
begin
  if (FDMClienteFornecedor.TEnderecocodigoTipoEndereco.Value > 0) then
  begin
    FDMTipoEndereco.consultarDados(FDMClienteFornecedor.TEnderecocodigoTipoEndereco.Value);

    if (FDMTipoEndereco.TTipoEndereco.RecordCount > 0) then
    begin
      FDMClienteFornecedor.TEnderecocodigoTipoEndereco.Value := FDMTipoEndereco.TTipoEnderecocodigo.Value;
      FDMClienteFornecedor.TEnderecoTipoEndereco.Value := FDMTipoEndereco.TTipoEnderecodescricao.Value;
    end
    else
    begin
      DBDescricaoDblClick(nil);
    end;
  end
  else
  begin
    DBDescricaoDblClick(nil);
  end;
end;

procedure TFEndereco.DBCidadeDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFCidade, FCidade);
    FCidade.consulta := True;
    FCidade.ShowModal;
  finally
    FDMClienteFornecedor.TEnderecocodigoCidade.Value := FDMCidade.TCidadecodigo.Value;
    FreeAndNil(FCidade);
    DBCidadeExit(nil);
  end;
end;

procedure TFEndereco.DBCidadeExit(Sender: TObject);
begin
  if (FDMClienteFornecedor.TEnderecocodigoCidade.Value > 0) then
  begin
    FDMCidade.consultarDados(FDMClienteFornecedor.TEnderecocodigoCidade.Value);

    if (FDMCidade.TCidade.RecordCount > 0) then
    begin
      FDMClienteFornecedor.TEnderecocodigoCidade.Value := FDMCidade.TCidadecodigo.Value;
      FDMClienteFornecedor.TEndereconomeCidade.Value := FDMCidade.TCidadenome.Value;
      FDMClienteFornecedor.TEndereconomeEstado.Value := FDMCidade.TCidadenomeEstado.Value;
      FDMClienteFornecedor.TEndereconomePais.Value := FDMCidade.TCidadenomePais.Value;
    end
    else
    begin
      DBCidadeDblClick(nil);
    end;
  end
  else
  begin
    DBCidadeDblClick(nil);
  end;
end;

procedure TFEndereco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDMClienteFornecedor.TEndereco.State in[dsInsert, dsEdit] then
  begin
    FDMClienteFornecedor.TEndereco.Cancel;
  end;
end;

function TFEndereco.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  with FDMClienteFornecedor do
  begin
    if not (TEnderecocodigoTipoEndereco.Value > 0) then
    begin
      mensagem.Add('A descri��o do endere�o deve ser selecionada!');
    end;

    if (TEnderecocep.Value = '') then
    begin
      mensagem.Add('O CEP deve ser informado!');
    end
    else if (Length(soNumeros(Trim(TEnderecocep.Value))) <> 8) then
    begin
      mensagem.Add('O CEP informado � invalido, ele deve conter 8 caracteres numericos validos!');
    end;

    if (TEnderecolongradouro.Value = '') then
    begin
      mensagem.Add('O Longradouro deve ser informado!');
    end;

    if (TEndereconumero.Value = '') then
    begin
      mensagem.Add('O numero deve ser informado!');
    end;

    if (TEnderecobairro.Value = '') then
    begin
      mensagem.Add('O bairro deve ser informado!');
    end;

    if not (TEnderecocodigoCidade.Value > 0) then
    begin
      mensagem.Add('A cidade deve ser selecionada!');
    end;

    if (TEnderecoprioridade.Value = '') then
    begin
      mensagem.Add('O tipo do endere�o deve ser selecionado!');
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
