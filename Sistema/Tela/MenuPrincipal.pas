unit MenuPrincipal;

interface

uses System.ImageList, Vcl.ImgList, Vcl.Controls, Vcl.Menus, System.Classes,
  Vcl.StdCtrls, Vcl.Forms, Winapi.Windows, System.SysUtils, UConexao;

type
  TFMenuPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    cadastro1: TMenuItem;
    cliente1: TMenuItem;
    fornecedor1: TMenuItem;
    usuario1: TMenuItem;
    pais1: TMenuItem;
    estado1: TMenuItem;
    cidade1: TMenuItem;
    tipoDocumento1: TMenuItem;
    tipoEndereco1: TMenuItem;
    sair1: TMenuItem;
    LMensagemPrincipal: TLabel;
    LRodape: TLabel;
    ImageList1: TImageList;
    Funcionario1: TMenuItem;
    Funcao1: TMenuItem;
    EmpresaFaturamento1: TMenuItem;
    Grupo1: TMenuItem;
    OrdemdeServio1: TMenuItem;
    procedure sair1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pais1Click(Sender: TObject);
    procedure estado1Click(Sender: TObject);
    procedure cidade1Click(Sender: TObject);
    procedure tipoDocumento1Click(Sender: TObject);
    procedure tipoEndereco1Click(Sender: TObject);
    procedure cliente1Click(Sender: TObject);
    procedure fornecedor1Click(Sender: TObject);
    procedure usuario1Click(Sender: TObject);
    procedure Funcionario1Click(Sender: TObject);
    procedure Funcao1Click(Sender: TObject);
    procedure EmpresaFaturamento1Click(Sender: TObject);
    procedure Grupo1Click(Sender: TObject);
    procedure OrdemdeServio1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenuPrincipal: TFMenuPrincipal;

implementation

uses UFuncao, Pais, Estado, Cidade, TipoDocumento, TipoEndereco, Funcao, Grupo,
     OrdemServico, Senha, DMPessoa;

{$R *.dfm}

procedure TFMenuPrincipal.cidade1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFCidade, FCidade);
    FCidade.ShowModal;
  finally
    FreeAndNil(FCidade);
  end;
end;

procedure TFMenuPrincipal.cliente1Click(Sender: TObject);
begin
  abreTelaCliente(False);
end;

procedure TFMenuPrincipal.EmpresaFaturamento1Click(Sender: TObject);
begin
  abreTelaEmpresa(False);
end;

procedure TFMenuPrincipal.estado1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFEstado, FEstado);
    FEstado.ShowModal;
  finally
    FreeAndNil(FEstado);
  end;
end;

procedure TFMenuPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Sair1Click(nil);
end;

procedure TFMenuPrincipal.FormShow(Sender: TObject);
begin
  try
    Application.CreateForm(TFSenha, FSenha);

    if (FSenha.ShowModal <> mrok) then
    begin
      ExitProcess(0);
    end;
  finally
    FreeAndNil(FSenha);
  end;
end;

procedure TFMenuPrincipal.fornecedor1Click(Sender: TObject);
begin
  abreTelaFornecedor(False);
end;

procedure TFMenuPrincipal.Funcao1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFFuncao, FFuncao);
    FFuncao.ShowModal;
  finally
    FreeAndNil(FFuncao);
  end;
end;

procedure TFMenuPrincipal.Funcionario1Click(Sender: TObject);
begin
  abreTelaFuncionario(False);
end;

procedure TFMenuPrincipal.Grupo1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFGrupo, FGrupo);
    FGrupo.ShowModal;
  finally
    FreeAndNil(FGrupo);
  end;
end;

procedure TFMenuPrincipal.OrdemdeServio1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFOrdemServico, FOrdemServico);
    FOrdemServico.ShowModal;
  finally
    FreeAndNil(FOrdemServico);
  end;
end;

procedure TFMenuPrincipal.pais1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFPais, FPais);
    FPais.ShowModal;
  finally
    FreeAndNil(FPais);
  end;
end;

procedure TFMenuPrincipal.sair1Click(Sender: TObject);
begin
  if confirmar('Realmente deseja sair do sistema?') then
  begin
    FDMPessoa.logout;
    ExitProcess(0);
  end
  else
  begin
    Abort;
  end;
end;

procedure TFMenuPrincipal.tipoDocumento1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFTipoDocumento, FTipoDocumento);
    FTipoDocumento.ShowModal;
  finally
    FreeAndNil(FTipoDocumento);
  end;
end;

procedure TFMenuPrincipal.tipoEndereco1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFTipoEndereco, FTipoEndereco);
    FTipoEndereco.ShowModal;
  finally
    FreeAndNil(FTipoEndereco);
  end;
end;

procedure TFMenuPrincipal.usuario1Click(Sender: TObject);
begin
  abreTelaUsuario(False);
end;

end.
