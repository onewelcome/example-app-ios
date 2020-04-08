//
//  AppConteiner.swift
//  OneginiExampleAppSwift
//
//  Created by Łukasz Łabuński on 08/04/2020.
//  Copyright © 2020 Onegini. All rights reserved.
//

import Dip

let container = DependencyContainer(configBlock: configureContainer)

func configureContainer(container rootContainer: DependencyContainer) {
    rootContainer.register(.singleton) { UINavigationController() }

    rootContainer.register { WelcomeViewController(welcomePresenterProtocol: try rootContainer.resolve() as WelcomePresenterProtocol) }

    rootContainer.register(.singleton) { AppRouter(startupPresenter: try rootContainer.resolve() as StartupPresenterProtocol,
        welcomePresenter: try rootContainer.resolve() as WelcomePresenterProtocol,
        dashboardPresenter: try rootContainer.resolve() as DashboardPresenterProtocol,
        errorPresenter: try rootContainer.resolve() as ErrorPresenterProtocol) as AppRouterProtocol }

    rootContainer.register { StartupPresenter(startupInteractor: try rootContainer.resolve() as StartupInteractorProtocol,
        navigationController: try rootContainer.resolve() as UINavigationController) as StartupPresenterProtocol }

    rootContainer.register { StartupInteractor() as StartupInteractorProtocol }

    rootContainer.register { StartupViewController() }

    rootContainer.register { WelcomePresenter(loginPresenter: try rootContainer.resolve() as LoginPresenterProtocol,
        registerUserPresenter: try rootContainer.resolve() as RegisterUserPresenterProtocol,
        navigationController: try rootContainer.resolve() as UINavigationController) as WelcomePresenterProtocol }

    rootContainer.register { LoginPresenter(loginInteractor: try rootContainer.resolve() as LoginInteractorProtocol,
        navigationController: try rootContainer.resolve() as UINavigationController,
        loginViewController: try rootContainer.resolve() as LoginViewController) as LoginPresenterProtocol }

    rootContainer.register { LoginInteractor() as LoginInteractorProtocol }
        .resolvingProperties { (conteiner, interactor) in
            (interactor as! LoginInteractor).loginPresenter = try rootContainer.resolve() as LoginPresenterProtocol
    }

    rootContainer.register { LoginViewController() }
    
    rootContainer.register { (idenitityProviders:[ONGIdentityProvider]) in
        RegisterUserViewController(registerUserViewToPresenterProtocol: try rootContainer.resolve() as RegisterUserPresenterProtocol,
                                   identityProviders: idenitityProviders) as RegisterUserViewController}

    rootContainer.register { RegisterUserPresenter(registerUserInteractor: try rootContainer.resolve() as RegisterUserInteractorProtocol,
        navigationController: try rootContainer.resolve() as UINavigationController) as RegisterUserPresenterProtocol }

    rootContainer.register { RegisterUserInteractor() as RegisterUserInteractorProtocol }
        .resolvingProperties { (conteiner, interactor) in
            (interactor as! RegisterUserInteractor).registerUserPresenter = try conteiner.resolve() as RegisterUserPresenterProtocol
    }

    rootContainer.register { DashboardPresenter(logoutInteractor: try rootContainer.resolve() as LogoutInteractorProtocol,
        navigationController: try rootContainer.resolve() as UINavigationController) as DashboardPresenterProtocol }

    rootContainer.register { LogoutInteractor() as LogoutInteractorProtocol }
        .resolvingProperties { (container, interactor) in
            (interactor as! LogoutInteractor).dashboardPresenter = try container.resolve() as DashboardPresenterProtocol
    }
    
    rootContainer.register { ErrorPresenter(navigationController: try rootContainer.resolve() as UINavigationController) as ErrorPresenterProtocol }
}
