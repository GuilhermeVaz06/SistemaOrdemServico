object FGrupo: TFGrupo
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Custos'
  ClientHeight = 531
  ClientWidth = 1363
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
    Width = 1363
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
      DataSource = FDMGrupo.DGrupo
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alLeft
      TabOrder = 0
    end
  end
  object PDados: TPanel
    Left = 0
    Top = 29
    Width = 281
    Height = 502
    Align = alLeft
    Enabled = False
    TabOrder = 1
    ExplicitLeft = -2
    ExplicitTop = 34
    object Label1: TLabel
      Left = 9
      Top = 3
      Width = 39
      Height = 16
      Caption = 'Codigo'
    end
    object Label2: TLabel
      Left = 91
      Top = 3
      Width = 55
      Height = 16
      Caption = 'Descri'#231#227'o'
    end
    object Label3: TLabel
      Left = 10
      Top = 47
      Width = 81
      Height = 16
      Caption = 'Sub Descri'#231#227'o'
    end
    object Label9: TLabel
      Left = 190
      Top = 47
      Width = 30
      Height = 16
      Caption = 'Valor'
    end
    object ECodigo: TDBEdit
      Left = 9
      Top = 20
      Width = 76
      Height = 24
      TabStop = False
      Color = clBtnFace
      DataField = 'codigo'
      DataSource = FDMGrupo.DGrupo
      ReadOnly = True
      TabOrder = 0
    end
    object EDescricao: TDBEdit
      Left = 91
      Top = 20
      Width = 185
      Height = 24
      DataField = 'descricao'
      DataSource = FDMGrupo.DGrupo
      TabOrder = 1
    end
    object CBAtivo: TDBCheckBox
      Left = 1
      Top = 484
      Width = 279
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMGrupo.DGrupo
      Enabled = False
      TabOrder = 5
      ValueChecked = 'A'
      ValueUnchecked = 'I'
      ExplicitWidth = 297
    end
    object Panel4: TPanel
      Left = 1
      Top = 381
      Width = 279
      Height = 103
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      ExplicitWidth = 297
      object Label4: TLabel
        Left = 9
        Top = 3
        Width = 88
        Height = 16
        Caption = 'Cadastrado Por'
      end
      object Label5: TLabel
        Left = 145
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
        Left = 145
        Top = 47
        Width = 84
        Height = 16
        Caption = 'Data Altera'#231#227'o'
      end
      object ECadastradoPor: TDBEdit
        Left = 9
        Top = 20
        Width = 130
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'cadastradoPor'
        DataSource = FDMGrupo.DGrupo
        ReadOnly = True
        TabOrder = 0
      end
      object EAlteradoPor: TDBEdit
        Left = 145
        Top = 20
        Width = 130
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'alteradoPor'
        DataSource = FDMGrupo.DGrupo
        ReadOnly = True
        TabOrder = 1
      end
      object EDataCadastro: TDBEdit
        Left = 9
        Top = 64
        Width = 130
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'dataCadastro'
        DataSource = FDMGrupo.DGrupo
        ReadOnly = True
        TabOrder = 2
      end
      object EDataAlteracao: TDBEdit
        Left = 145
        Top = 64
        Width = 130
        Height = 24
        TabStop = False
        Color = clBtnFace
        DataField = 'dataAlteracao'
        DataSource = FDMGrupo.DGrupo
        ReadOnly = True
        TabOrder = 3
      end
    end
    object DBEdit1: TDBEdit
      Left = 9
      Top = 64
      Width = 174
      Height = 24
      DataField = 'subDescricao'
      DataSource = FDMGrupo.DGrupo
      TabOrder = 2
    end
    object DBEdit2: TDBEdit
      Left = 189
      Top = 64
      Width = 87
      Height = 24
      DataField = 'valor'
      DataSource = FDMGrupo.DGrupo
      TabOrder = 3
    end
  end
  object PGrid: TPanel
    Left = 281
    Top = 29
    Width = 1082
    Height = 502
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 299
    ExplicitWidth = 1064
    object Panel2: TPanel
      Left = 1
      Top = 471
      Width = 1080
      Height = 30
      Align = alBottom
      TabOrder = 2
      ExplicitWidth = 1062
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
      Width = 1080
      Height = 52
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 1062
      object BConsultar: TSpeedButton
        Left = 458
        Top = 13
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
      object Label8: TLabel
        Left = 232
        Top = 0
        Width = 81
        Height = 16
        Caption = 'Sub Descri'#231#227'o'
      end
      object ELocalizarDescricao: TEdit
        Left = 3
        Top = 18
        Width = 220
        Height = 24
        TabOrder = 0
      end
      object ESubDescricao: TEdit
        Left = 232
        Top = 18
        Width = 220
        Height = 24
        TabOrder = 1
      end
    end
    object GDados: TDBGrid
      Left = 1
      Top = 53
      Width = 1080
      Height = 418
      Align = alClient
      DataSource = FDMGrupo.DGrupo
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
          FieldName = 'descricao'
          Title.Alignment = taCenter
          Title.Caption = 'Descri'#231#227'o'
          Width = 154
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'subDescricao'
          Title.Alignment = taCenter
          Title.Caption = 'Sub Descri'#231#227'o'
          Width = 144
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor'
          Title.Alignment = taCenter
          Title.Caption = 'Valor'
          Width = 97
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
