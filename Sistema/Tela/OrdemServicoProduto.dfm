object FOrdemServicoProduto: TFOrdemServicoProduto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastrar Servi'#231'o'
  ClientHeight = 147
  ClientWidth = 574
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
    Width = 574
    Height = 112
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 7
      Top = 2
      Width = 55
      Height = 16
      Caption = 'Descri'#231#227'o'
    end
    object Label1: TLabel
      Left = 8
      Top = 46
      Width = 65
      Height = 16
      Caption = 'Quantidade'
    end
    object Label2: TLabel
      Left = 102
      Top = 46
      Width = 78
      Height = 16
      Caption = 'Valor Unitario'
    end
    object Label4: TLabel
      Left = 196
      Top = 46
      Width = 63
      Height = 16
      Caption = 'Valor Total'
    end
    object Label5: TLabel
      Left = 290
      Top = 46
      Width = 52
      Height = 16
      Caption = 'Desconto'
    end
    object Label6: TLabel
      Left = 384
      Top = 46
      Width = 86
      Height = 16
      Caption = 'Valor Desconto'
    end
    object Label7: TLabel
      Left = 476
      Top = 46
      Width = 61
      Height = 16
      Caption = 'Valor Final'
    end
    object Label8: TLabel
      Left = 476
      Top = 2
      Width = 46
      Height = 16
      Caption = 'Unidade'
    end
    object DBDocumento: TDBEdit
      Left = 6
      Top = 19
      Width = 464
      Height = 24
      DataField = 'descricao'
      DataSource = FDMOrdemServico.DProduto
      TabOrder = 0
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 95
      Width = 574
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMOrdemServico.DProduto
      TabOrder = 7
      ValueChecked = 'A'
      ValueUnchecked = 'I'
    end
    object DBEdit1: TDBEdit
      Left = 8
      Top = 63
      Width = 88
      Height = 24
      DataField = 'quantidade'
      DataSource = FDMOrdemServico.DProduto
      TabOrder = 1
      OnExit = DBEdit2Exit
    end
    object DBEdit2: TDBEdit
      Left = 102
      Top = 63
      Width = 88
      Height = 24
      DataField = 'valorUnitario'
      DataSource = FDMOrdemServico.DProduto
      TabOrder = 2
      OnExit = DBEdit2Exit
    end
    object DBEdit3: TDBEdit
      Left = 196
      Top = 63
      Width = 88
      Height = 24
      TabStop = False
      DataField = 'valorTotal'
      DataSource = FDMOrdemServico.DProduto
      ReadOnly = True
      TabOrder = 3
      OnExit = DBEdit2Exit
    end
    object DBEdit4: TDBEdit
      Left = 290
      Top = 63
      Width = 88
      Height = 24
      DataField = 'desconto'
      DataSource = FDMOrdemServico.DProduto
      TabOrder = 4
      OnExit = DBEdit2Exit
    end
    object DBEdit5: TDBEdit
      Left = 384
      Top = 63
      Width = 88
      Height = 24
      TabStop = False
      DataField = 'valorDesconto'
      DataSource = FDMOrdemServico.DProduto
      ReadOnly = True
      TabOrder = 5
      OnExit = DBEdit2Exit
    end
    object DBEdit6: TDBEdit
      Left = 476
      Top = 63
      Width = 88
      Height = 24
      TabStop = False
      DataField = 'valorFinal'
      DataSource = FDMOrdemServico.DProduto
      ReadOnly = True
      TabOrder = 6
      OnExit = DBEdit2Exit
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 476
      Top = 19
      Width = 88
      Height = 24
      DataField = 'unidade'
      DataSource = FDMOrdemServico.DProduto
      KeyField = 'descricao'
      ListField = 'descricao'
      ListSource = FDMOrdemServico.DUnidade
      TabOrder = 8
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 112
    Width = 574
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object BConfirmar: TSpeedButton
      Left = 478
      Top = 0
      Width = 96
      Height = 34
      Align = alRight
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      OnClick = BConfirmarClick
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
