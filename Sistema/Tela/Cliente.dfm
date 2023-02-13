object FCliente: TFCliente
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Cliente'
  ClientHeight = 614
  ClientWidth = 1395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1395
    Height = 29
    Align = alTop
    TabOrder = 0
    object BFechar: TSpeedButton
      Left = 628
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Fechar'
      ImageIndex = 6
      Images = FMenuPrincipal.ImageList1
      OnClick = BFecharClick
      ExplicitLeft = 640
      ExplicitTop = -4
      ExplicitHeight = 39
    end
    object BConfirmar: TSpeedButton
      Left = 532
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      Enabled = False
      OnClick = BConfirmarClick
      ExplicitLeft = 615
      ExplicitTop = -4
      ExplicitHeight = 39
    end
    object BCancelar: TSpeedButton
      Left = 436
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Cancelar'
      ImageIndex = 4
      Images = FMenuPrincipal.ImageList1
      Enabled = False
      OnClick = BCancelarClick
      ExplicitLeft = 519
      ExplicitTop = -4
      ExplicitHeight = 39
    end
    object BInativar: TSpeedButton
      Left = 340
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Inativar'
      ImageIndex = 2
      Images = FMenuPrincipal.ImageList1
      OnClick = BInativarClick
      ExplicitLeft = 327
      ExplicitTop = -4
      ExplicitHeight = 39
    end
    object BAlterar: TSpeedButton
      Left = 244
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Alterar'
      ImageIndex = 1
      Images = FMenuPrincipal.ImageList1
      OnClick = BAlterarClick
      ExplicitLeft = 135
      ExplicitTop = -4
      ExplicitHeight = 39
    end
    object BCadastrar: TSpeedButton
      Left = 148
      Top = 1
      Width = 96
      Height = 27
      Align = alLeft
      Caption = 'Cadastrar'
      ImageIndex = 0
      Images = FMenuPrincipal.ImageList1
      OnClick = BCadastrarClick
      ExplicitLeft = 1
      ExplicitTop = -1
      ExplicitHeight = 39
    end
    object DBNavigator1: TDBNavigator
      Left = 1
      Top = 1
      Width = 147
      Height = 27
      DataSource = FDMCliente.DCliente
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alLeft
      TabOrder = 0
    end
  end
  object PDados: TPanel
    Left = 0
    Top = 29
    Width = 390
    Height = 585
    Align = alLeft
    Enabled = False
    TabOrder = 1
    object CBAtivo: TDBCheckBox
      Left = 1
      Top = 567
      Width = 388
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMCliente.DCliente
      TabOrder = 3
      ValueChecked = 'A'
      ValueUnchecked = 'I'
    end
    object Panel4: TPanel
      Left = 1
      Top = 464
      Width = 388
      Height = 103
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object Label4: TLabel
        Left = 9
        Top = 3
        Width = 88
        Height = 16
        Caption = 'Cadastrado Por'
      end
      object Label5: TLabel
        Left = 199
        Top = 3
        Width = 71
        Height = 16
        Caption = 'Alterado Por'
      end
      object Label6: TLabel
        Left = 9
        Top = 47
        Width = 81
        Height = 16
        Caption = 'Data Cadastro'
      end
      object Label7: TLabel
        Left = 199
        Top = 47
        Width = 84
        Height = 16
        Caption = 'Data Altera'#231#227'o'
      end
      object ECadastradoPor: TDBEdit
        Left = 9
        Top = 20
        Width = 184
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'cadastradoPor'
        DataSource = FDMCliente.DCliente
        ReadOnly = True
        TabOrder = 0
      end
      object EAlteradoPor: TDBEdit
        Left = 199
        Top = 20
        Width = 184
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'alteradoPor'
        DataSource = FDMCliente.DCliente
        ReadOnly = True
        TabOrder = 1
      end
      object EDataCadastro: TDBEdit
        Left = 9
        Top = 64
        Width = 184
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'dataCadastro'
        DataSource = FDMCliente.DCliente
        ReadOnly = True
        TabOrder = 2
      end
      object EDataAlteracao: TDBEdit
        Left = 199
        Top = 64
        Width = 184
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'dataAlteracao'
        DataSource = FDMCliente.DCliente
        ReadOnly = True
        TabOrder = 3
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 388
      Height = 237
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 9
        Top = 1
        Width = 39
        Height = 16
        Caption = 'Codigo'
      end
      object Label2: TLabel
        Left = 90
        Top = 1
        Width = 64
        Height = 16
        Caption = 'Documento'
      end
      object Label3: TLabel
        Left = 199
        Top = 1
        Width = 82
        Height = 16
        Caption = 'N'#186' Documento'
      end
      object Label8: TLabel
        Left = 9
        Top = 47
        Width = 73
        Height = 16
        Caption = 'Raz'#227'o Social'
      end
      object Label9: TLabel
        Left = 199
        Top = 47
        Width = 85
        Height = 16
        Caption = 'Nome Fantasia'
      end
      object Label11: TLabel
        Left = 9
        Top = 95
        Width = 50
        Height = 16
        Caption = 'Telefone'
      end
      object Label12: TLabel
        Left = 199
        Top = 95
        Width = 35
        Height = 16
        Caption = 'E-Mail'
      end
      object Label13: TLabel
        Left = 8
        Top = 144
        Width = 67
        Height = 16
        Caption = 'Observa'#231#227'o'
      end
      object ECodigo: TDBEdit
        Left = 9
        Top = 17
        Width = 76
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'codigo'
        DataSource = FDMCliente.DCliente
        ReadOnly = True
        TabOrder = 0
      end
      object DBDocumento: TDBEdit
        Left = 199
        Top = 17
        Width = 183
        Height = 24
        DataField = 'documento'
        DataSource = FDMCliente.DCliente
        TabOrder = 2
        OnExit = DBDocumentoExit
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 90
        Top = 17
        Width = 102
        Height = 24
        DataField = 'codigoTipoDocumento'
        DataSource = FDMCliente.DCliente
        KeyField = 'codigo'
        ListField = 'descricao'
        ListSource = FDMCliente.DTipoDocumento
        TabOrder = 1
        OnClick = DBLookupComboBox1Click
        OnExit = DBLookupComboBox1Exit
      end
      object DBEdit1: TDBEdit
        Left = 9
        Top = 66
        Width = 184
        Height = 24
        DataField = 'razaoSocial'
        DataSource = FDMCliente.DCliente
        TabOrder = 3
      end
      object DBEdit2: TDBEdit
        Left = 199
        Top = 66
        Width = 184
        Height = 24
        DataField = 'nomeFantasia'
        DataSource = FDMCliente.DCliente
        TabOrder = 4
      end
      object DBEdit3: TDBEdit
        Left = 9
        Top = 114
        Width = 184
        Height = 24
        DataField = 'telefone'
        DataSource = FDMCliente.DCliente
        TabOrder = 5
      end
      object DBEdit4: TDBEdit
        Left = 199
        Top = 114
        Width = 184
        Height = 24
        DataField = 'email'
        DataSource = FDMCliente.DCliente
        TabOrder = 6
      end
      object DBMemo1: TDBMemo
        Left = 9
        Top = 161
        Width = 374
        Height = 71
        DataField = 'observacao'
        DataSource = FDMCliente.DCliente
        ScrollBars = ssVertical
        TabOrder = 7
      end
    end
    object PCDados: TPageControl
      Left = 1
      Top = 238
      Width = 388
      Height = 226
      ActivePage = TBOutrosDocumentos
      Align = alClient
      TabOrder = 1
      ExplicitLeft = -3
      ExplicitTop = 239
      object TBOutrosDocumentos: TTabSheet
        Caption = 'Outros Documentos'
      end
      object TBEndereco: TTabSheet
        Caption = 'Endere'#231'o'
        ImageIndex = 1
      end
      object TBContato: TTabSheet
        Caption = 'Outros Contatos'
        ImageIndex = 2
      end
    end
  end
  object PGrid: TPanel
    Left = 390
    Top = 29
    Width = 1005
    Height = 585
    Align = alClient
    TabOrder = 2
    object Panel2: TPanel
      Left = 1
      Top = 554
      Width = 1003
      Height = 30
      Align = alBottom
      TabOrder = 2
      object CBMostrarInativo: TCheckBox
        Left = 9
        Top = 6
        Width = 117
        Height = 17
        Caption = 'Mostrar Inativos'
        TabOrder = 0
        OnClick = CBMostrarInativoClick
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 1003
      Height = 52
      Align = alTop
      TabOrder = 0
      object BConsultar: TSpeedButton
        Left = 413
        Top = 14
        Width = 96
        Height = 30
        Caption = 'Consultar'
        ImageIndex = 7
        Images = FMenuPrincipal.ImageList1
        OnClick = BConsultarClick
      end
      object Label10: TLabel
        Left = 3
        Top = 0
        Width = 55
        Height = 16
        Caption = 'Descri'#231#227'o'
      end
      object ELocalizarDescricao: TEdit
        Left = 3
        Top = 18
        Width = 402
        Height = 24
        TabOrder = 0
      end
    end
    object GDados: TDBGrid
      Left = 1
      Top = 53
      Width = 1003
      Height = 501
      Align = alClient
      DataSource = FDMCliente.DCliente
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = GDadosDrawColumnCell
      OnDblClick = GDadosDblClick
      OnTitleClick = GDadosTitleClick
      Columns = <
        item
          Expanded = False
          FieldName = 'codigo'
          Title.Alignment = taCenter
          Title.Caption = 'Codigo'
          Width = 65
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tipoDocumento'
          Title.Alignment = taCenter
          Title.Caption = 'Documento'
          Width = 78
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'documento'
          Title.Alignment = taCenter
          Title.Caption = 'N'#186' Documento'
          Width = 114
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'razaoSocial'
          Title.Alignment = taCenter
          Title.Caption = 'Raz'#227'o Social'
          Width = 126
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nomeFantasia'
          Title.Alignment = taCenter
          Title.Caption = 'Nome Fantasia'
          Width = 117
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'telefone'
          Title.Alignment = taCenter
          Title.Caption = 'Telefone'
          Width = 114
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'email'
          Title.Alignment = taCenter
          Title.Caption = 'Email'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'observacao'
          Title.Alignment = taCenter
          Title.Caption = 'Observa'#231#227'o'
          Width = 135
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cadastradoPor'
          Title.Alignment = taCenter
          Title.Caption = 'Cadastrado Por'
          Width = 143
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'alteradoPor'
          Title.Alignment = taCenter
          Title.Caption = 'Alterado Por'
          Width = 152
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dataCadastro'
          Title.Alignment = taCenter
          Title.Caption = 'Data Cadastro'
          Width = 154
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dataAlteracao'
          Title.Alignment = taCenter
          Title.Caption = 'Data Altera'#231#227'o'
          Width = 153
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'status'
          Title.Alignment = taCenter
          Title.Caption = 'Status'
          Width = 61
          Visible = True
        end>
    end
  end
end
