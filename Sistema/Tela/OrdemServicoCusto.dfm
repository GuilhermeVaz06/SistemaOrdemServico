object FOrdemServicoCusto: TFOrdemServicoCusto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastrar Custo'
  ClientHeight = 101
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 758
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 103
      Top = 2
      Width = 55
      Height = 16
      Caption = 'Descri'#231#227'o'
    end
    object Label1: TLabel
      Left = 477
      Top = 2
      Width = 65
      Height = 16
      Caption = 'Quantidade'
    end
    object Label2: TLabel
      Left = 571
      Top = 2
      Width = 78
      Height = 16
      Caption = 'Valor Unitario'
    end
    object Label4: TLabel
      Left = 665
      Top = 2
      Width = 63
      Height = 16
      Caption = 'Valor Total'
    end
    object Label5: TLabel
      Left = 9
      Top = 2
      Width = 34
      Height = 16
      Caption = 'Grupo'
    end
    object Label6: TLabel
      Left = 290
      Top = 2
      Width = 81
      Height = 16
      Caption = 'Sub Descri'#231#227'o'
    end
    object DBDocumento: TDBEdit
      Left = 102
      Top = 19
      Width = 181
      Height = 24
      TabStop = False
      DataField = 'descricao'
      DataSource = FDMOrdemServico.DCusto
      ReadOnly = True
      TabOrder = 1
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 48
      Width = 758
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMOrdemServico.DCusto
      TabOrder = 6
      ValueChecked = 'A'
      ValueUnchecked = 'I'
      ExplicitTop = 95
      ExplicitWidth = 574
    end
    object DBEdit1: TDBEdit
      Left = 477
      Top = 19
      Width = 88
      Height = 24
      DataField = 'quantidade'
      DataSource = FDMOrdemServico.DCusto
      TabOrder = 3
      OnExit = DBEdit2Exit
    end
    object DBEdit2: TDBEdit
      Left = 571
      Top = 19
      Width = 88
      Height = 24
      DataField = 'valorUnitario'
      DataSource = FDMOrdemServico.DCusto
      TabOrder = 4
      OnExit = DBEdit2Exit
    end
    object DBEdit3: TDBEdit
      Left = 665
      Top = 19
      Width = 88
      Height = 24
      TabStop = False
      DataField = 'valorTotal'
      DataSource = FDMOrdemServico.DCusto
      ReadOnly = True
      TabOrder = 5
      OnExit = DBEdit2Exit
    end
    object DBGrupo: TDBEdit
      Left = 8
      Top = 19
      Width = 88
      Height = 24
      DataField = 'codigoGrupo'
      DataSource = FDMOrdemServico.DCusto
      TabOrder = 0
      OnDblClick = DBGrupoDblClick
      OnExit = DBGrupoExit
    end
    object DBEdit5: TDBEdit
      Left = 289
      Top = 19
      Width = 181
      Height = 24
      TabStop = False
      DataField = 'subDescricao'
      DataSource = FDMOrdemServico.DCusto
      ReadOnly = True
      TabOrder = 2
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 65
    Width = 758
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 112
    ExplicitWidth = 574
    object BConfirmar: TSpeedButton
      Left = 662
      Top = 0
      Width = 96
      Height = 34
      Align = alRight
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      OnClick = BConfirmarClick
      ExplicitLeft = 478
      ExplicitTop = -1
    end
    object BCancelar: TSpeedButton
      Left = 0
      Top = 0
      Width = 96
      Height = 34
      Align = alLeft
      Caption = 'Cancelar'
      ImageIndex = 4
      Images = FMenuPrincipal.ImageList1
      OnClick = BCancelarClick
      ExplicitLeft = 1
      ExplicitTop = -1
      ExplicitHeight = 39
    end
  end
end
