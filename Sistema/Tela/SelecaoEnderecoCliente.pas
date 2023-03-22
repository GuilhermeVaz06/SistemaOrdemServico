unit SelecaoEnderecoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFSelecaoEnderecoCliente = class(TForm)
    GEndereco: TDBGrid;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure GEnderecoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GEnderecoTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSelecaoEnderecoCliente: TFSelecaoEnderecoCliente;

implementation

uses UFuncao, DMOrdemServico;

{$R *.dfm}

procedure TFSelecaoEnderecoCliente.GEnderecoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFSelecaoEnderecoCliente.GEnderecoTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

end.
