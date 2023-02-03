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
    procedure sair1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pais1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure estado1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenuPrincipal: TFMenuPrincipal;

implementation

uses UFuncao, Pais, Estado;

{$R *.dfm}

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
  SessaoLogado := 2;
  NomeUsuarioSessaoLogado := 'Guilherme';
  UsuarioAdmnistrador := True;
  SessaoLogadoToken := '96FC542F00DC204B1408A6314962E10A';
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
    ExitProcess(0);
  end
  else
  begin
    Abort;
  end;
end;

end.
