object FOutroDocumento: TFOutroDocumento
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastro de Outros Documentos'
  ClientHeight = 176
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 142
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 9
      Top = 2
      Width = 64
      Height = 16
      Caption = 'Documento'
    end
    object Label3: TLabel
      Left = 118
      Top = 2
      Width = 82
      Height = 16
      Caption = 'N'#186' Documento'
    end
    object Label1: TLabel
      Left = 306
      Top = 2
      Width = 77
      Height = 16
      Caption = 'Data Emiss'#227'o'
    end
    object Label4: TLabel
      Left = 423
      Top = 2
      Width = 97
      Height = 16
      Caption = 'Data Vencimento'
    end
    object Label22: TLabel
      Left = 9
      Top = 49
      Width = 67
      Height = 16
      Caption = 'Observa'#231#227'o'
    end
    object DBDocumento: TDBEdit
      Left = 117
      Top = 19
      Width = 183
      Height = 24
      DataField = 'documento'
      DataSource = FDMClienteFornecedor.DOutroDocumento
      TabOrder = 1
      OnExit = DBDocumentoExit
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 9
      Top = 19
      Width = 102
      Height = 24
      DataField = 'codigoTipoDocumento'
      DataSource = FDMClienteFornecedor.DOutroDocumento
      KeyField = 'codigo'
      ListField = 'descricao'
      ListSource = FDMClienteFornecedor.DTipoDocumento
      TabOrder = 0
      OnExit = DBLookupComboBox1Exit
    end
    object EDTEmissao: TDateTimePicker
      Left = 306
      Top = 19
      Width = 111
      Height = 24
      Date = 44975.000000000000000000
      Time = 0.918185462964174800
      TabOrder = 2
      OnChange = EDTEmissaoChange
    end
    object EDTVencimento: TDateTimePicker
      Left = 423
      Top = 19
      Width = 111
      Height = 24
      Date = 44975.000000000000000000
      Time = 0.918185462964174800
      TabOrder = 3
      OnChange = EDTVencimentoChange
    end
    object DBMemo1: TDBMemo
      Left = 9
      Top = 68
      Width = 525
      Height = 53
      DataField = 'observacao'
      DataSource = FDMClienteFornecedor.DOutroDocumento
      TabOrder = 4
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 125
      Width = 550
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMClienteFornecedor.DOutroDocumento
      TabOrder = 5
      ValueChecked = 'A'
      ValueUnchecked = 'I'
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 142
    Width = 550
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object BConfirmar: TSpeedButton
      Left = 454
      Top = 0
      Width = 96
      Height = 34
      Align = alRight
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      OnClick = BConfirmarClick
      ExplicitLeft = 0
      ExplicitTop = -3
      ExplicitHeight = 29
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
