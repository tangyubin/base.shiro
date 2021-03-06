package com.longdong.dao;

import com.longdong.entity.Organization;

import java.util.List;


public interface OrganizationDao {

    public Organization createOrganization(Organization organization);
    public Organization updateOrganization(Organization organization);
    public void deleteOrganization(Long organizationId);

    Organization findOne(Long organizationId);
    List<Organization> findAll();

    List<Organization> findAllWithExclude(Organization excludeOraganization);

    void move(Organization source, Organization target);
	public List<Organization> findOrganizationByParentId(long parentId);
	public int deleteOrganizations(String ids);
	public int findCount(Organization organization);
	public List<Organization> findAllOrganization(Organization organization);
}
