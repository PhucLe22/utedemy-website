package vn.iotstar.impl.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IRoleDao;
import vn.iotstar.dao.IUserDao;
import vn.iotstar.entity.Role;

public class RoleDao implements IRoleDao{
	
	public Role findById(int id) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
		    TypedQuery<Role> query = enma.createQuery("SELECT r FROM Role r WHERE r.id = :id", Role.class);
		    query.setParameter("id", id);
		    return query.getSingleResult();
		} finally {
		    enma.close();
		}
	}

}
